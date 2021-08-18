import Hash "mo:base/Hash";
import Types "Types";

module {
    public type Role = Types.Role;

    public func equal(r1 : Role, r2 : Role) : Bool {
        r1 == r2
    };

    public func max(r1 : Role, r2 : Role) : Role {
        switch (r1, r2) {
            case (#canisterOwner, _) { #canisterOwner };
            case (_, #canisterOwner) { #canisterOwner };
            case (#user, #user) { #user };
            case (#user, #guest) { #user };
            case (#guest, #user) { #user };
            case (#guest, #guest) { #guest };
        }
    };

    public func hash(r : Role) : Hash.Hash {
        switch r {
            case (#guest) 0;
            case (#user) 1;
            case (#canisterOwner) 100;
        };
    };
};
