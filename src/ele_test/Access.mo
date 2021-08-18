
import Array "mo:base/Array";
import Bool "mo:base/Bool";
import Debug "mo:base/Debug";
import HashMap "mo:base/HashMap";
import Int "mo:base/Int";
import Iter "mo:base/Iter";
import Option "mo:base/Option";
import Principal "mo:base/Principal";
import Text "mo:base/Text";

import Types "Types";
import Role "Role";
import Rel "Rel";
import RelObj "RelObj";
import SeqObj "SeqObj";

module {

    type HashMap<X, Y> = HashMap.HashMap<X, Y>;

    type DappId = Types.DappId;
    type UserPrincipal = Types.UserPrincipal;

    type Rel<X, Y> = RelObj.RelObj<X, Y>;

    /// Access control log stores all of the checks and their outcomes,
    // e.g., for debugging and auditing security.
    public module Log {
        public module Check {
            /// An access check consists of a caller, a username and a user action.
            public type Check = {
                caller : UserPrincipal;
                role : Types.Role;
                userAction : Types.UserAction;
                actionTarget : Types.ActionTarget
            };
        };

        public module Event {
            /// An access event is an access control check, its calling context, and its outcome.
            public type Event = {
                time : Int; // using mo:base/Time and Time.now() : Int
                check : Check.Check;
                isOk : Bool;
            };

            public func equal(x:Event, y:Event) : Bool { x == y };
        };

        // public type Log = SeqObj.Seq<Event.Event>;
    };

    public type AccessEvent = Log.Event.Event;

    public func accessEventToText(event: AccessEvent) : Text {
        Int.toText(event.time) # " -- " # checkToText(event.check) # " -- " # Bool.toText(event.isOk)
    };

    public func checkToText(c: Log.Check.Check) : Text {
         c.caller # " -- " # Types.roleToText(c.role) # " -- " # Types.userActionToText(c.userAction) # 
          " -- " # Types.actionTargetToText(c.actionTarget)
    };

    public class Access(   
        admin : UserPrincipal,
        dappWithOwners_ : HashMap<DappId, UserPrincipal>             // dapp和owner关系   
    ) {

        public func getAdmin() : UserPrincipal {
            admin
        };

        /// Relating usernames and roles.
        var userRole : RelObj.RelObj<Types.UserPrincipal, Types.Role> =
            RelObj.RelObj<Types.UserPrincipal, Role.Role>((Text.hash, Role.hash), (Text.equal, Role.equal));

        userRole.put(admin, #canisterOwner);

        let dappWithOwners : HashMap<DappId, UserPrincipal> = dappWithOwners_ ;             // dapp和owner关系
        
        /// Get the maximal role for a user.
        public func userMaxRole(user : Types.UserPrincipal) : Types.Role {
            let roles = userRole.get0(user);
            switch (roles.size()) {
                case 0 { #guest };
                case 1 { roles[0] };
                case 2 { Role.max(roles[0], roles[1]) };
                case 3 { Role.max(roles[0], Role.max(roles[1], roles[2])) };
                case _ {
                    // impossible, or broken invariants: only three possible roles.
                    assert false;
                    #guest
                };
            }
        };

        /// Add owner to the dapp
        public func addDappOwner(dappId: DappId, owner: UserPrincipal) {
            dappWithOwners.put(dappId, owner);
        };

        public func toShare() : { admin: UserPrincipal; dappWithOwners: [(DappId, UserPrincipal)]} {
            {
                admin = admin;
                dappWithOwners = Iter.toArray<(DappId, UserPrincipal)>(dappWithOwners.entries())
            }
        };

        /// Get the maximal role for a caller,
        /// considering all possible user names associated with principal.
        // public func callerMaxRole(p : Principal) : Types.Role {
        //     if (p == admin) { #canisterOwner } else {
        //         let usernames = userPrincipal.get1(p);
        //         let userRoles = Array.map<Types.UserPrincipal, Types.Role>(usernames, userMaxRole);
        //         Array.foldLeft(userRoles, #guest, Role.max)
        //     }
        // };

        /// Perform a systematic (and logged) service-access check.
        ////
        /// `check(caller, userAction, UserPrincipal)`
        /// checks that `userAction` is permitted by the caller as `UserPrincipal`,
        /// returning `?()` if so, and `null` otherwise.
        ///
        /// This function is meant to be used as a protective guard,
        /// starting each service call, before any other CanCan service logic,
        /// (before it changes or accesses any state, to guard against unauthorized access).
        ///
        /// To audit the CanCan service for security, we need to check that this call is used
        /// appropriately in each call, and that its logic (below) is correct.
        ///
        /// the logic is as follows:
        ///
        /// First, use the current state to resolve the caller Principal
        /// to all available roles, preferring the highest access according to the ordering:
        ///
        ///       (minimal access) #guest  <  #user  < #canisterOwner (maximal access)
        ///
        /// The role #guest is for new Principals that are not recognized.
        ///
        /// Then, we apply these role-based rules:
        ///
        /// a. guest，可以浏览公开的资源，不能上传和修改任何资源
        /// b. user表示注册用户，除了拥有guest的权限外，对自己创建的资源可以修改，删除，与其他user或资源交互
        /// c. canisterOwner是超级管理员，canisterOwner拥有包含user的权限，不限于某个app，拥有全部权限 
        ///
        public func check(
            time_ : Int,
            caller_ : UserPrincipal,
            userAction_ : Types.UserAction,
            actionTarget_ : Types.ActionTarget,
        ) : AccessEvent {
            let operationRole = userMaxRole(caller_);

            let canOperation = switch (operationRole) {
                case (#canisterOwner) {
                        // success; full power, and full responsibility.
                        ?()
                };
                case (#guest) {
                    // guests just create users.
                    if(userAction_ == #create or actionTarget_ == #pubView ) { ?() }
                    else { null }
                };
                case (#user) {
                    switch userAction_ {
                        case (#view) { ?() };
                        case (#create) { ?() };
                        case (#admin) { null };
                        case (#update) {
                            switch actionTarget_ {
                                case (#pubView) { ?() };
                                case (#all) { null };
                                case (#user i) { if (i == caller_) { ?() } else { null } };
                                case (#dapp v) { 
                                    switch (dappWithOwners.get(v)) {
                                        case (?owner) {
                                            if (caller_ == owner) { ?() } else { null };
                                        };
                                        case (null) { null };
                                    }
                                 };
                                case (#hackathon h) { null };
                            }
                        };
                    }
                };

            };

            let accessEvent : AccessEvent = {
                time = time_;
                caller = caller_;
                isOk = canOperation == ?();
                check = { 
                    caller = caller_;
                    role = operationRole;
                    userAction = userAction_;
                     actionTarget = actionTarget_ ; 
                } 
            };
            // print all access events for debugging
            Debug.print (debug_show accessEvent);
            // recall: this log will only be saved for updates, not queries; IC semantic rules.
            // log.add(accessEvent);
            accessEvent
        };
    };
}
