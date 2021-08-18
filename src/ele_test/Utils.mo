import Prim "mo:prim";

import Array "mo:base/Array";
import Char "mo:base/Char";
import Hash "mo:base/Hash";
import Int "mo:base/Int";
import Iter "mo:base/Iter";
import List "mo:base/List";
import Nat "mo:base/Nat";
import Order "mo:base/Order";
import Text "mo:base/Text";
import Trie "mo:base/Trie";

import Types "./Types";

module {

    type DappId = Types.DappId;
    // type UserId = Types.UserId;
    type UserPrincipal = Types.UserPrincipal;

    type DappStatistics = Types.DappStatistics;
    type DappStatisticsOp = Types.DappStatisticsOp;
    type DappStatisticsItem = Types.DappStatisticsItem;

    type DappShareId = Types.ShareId;

    type DBKey<K> = Types.DBKey<K>;

    /// User Principal eq
    public let principalEq = Text.equal;

    /// 辅助方法 User.equal
    public let userEq = Text.equal;

    /// 辅助方法，User的Trie.Key实例
    public func keyOfUser(k: UserPrincipal): DBKey<UserPrincipal> {
        { key = k; hash = Text.hash(k) }
    };

    /// 辅助方法 Dapp.equal
    public let dappEq = Nat.equal;

    /// 辅助方法，Dapp的Trie.Key实例
    public func keyOfDapp(k: DappId): DBKey<DappId> {
        { key = k; hash = Hash.hash(k) }
    };

    /// 辅助方法 DappShare主键相等
    public let dappShareEq = Nat.equal;

    /// 辅助方法 DappShare的Trie.Key实例
    public func keyOfDappShare(k: DappShareId): DBKey<DappShareId> {
        { key = k; hash = Hash.hash(k) }
    };

    /// Text 转为小写，在用户名之类的场景使用
    /// Convert text to lower case
    public func toLowerCase(name: Text) : Text {
        var str = "";
        for (c in Text.toIter(trim(name))) {
            let ch = if ('A' <= c and c <= 'Z') { Prim.charToLower(c) } else { c };
            str := str # Prim.charToText(ch);
        };
        str
    };
    /// 根据需要计算DappStats中的某个Statistics项计算
    public func computeStatsItem(ds: DappStatistics, dsItem: DappStatisticsItem, op: DappStatisticsOp) : DappStatistics {
        let profile = ds.profile;
        var likeCount = ds.likeCount;
        var shareCount = ds.shareCount;
        var rewardCount = ds.rewardCount;
        var commentCount = ds.commentCount;

        switch (dsItem) {
            case (#like) { likeCount := computeOp(likeCount, op) };
            case (#share) { shareCount := computeOp(shareCount, op) };
            case (#reward) { rewardCount := computeOp(rewardCount, op) };
            case (#comment) { commentCount := computeOp(commentCount, op) };
        };

        {
            profile = profile;
            likeCount = likeCount;
            shareCount = shareCount;
            rewardCount = rewardCount;
            commentCount = commentCount;
        }
    };

    /// Text trim
    public func trim(t: Text) : Text {
        let res = Text.trim(t, #text " ");
        res
    };

    /// 根据运算符计算结果
    public func computeOp(value: Nat, op: DappStatisticsOp) : Nat {
        switch (op) {
            case (#addOne) value + 1;
            case (#subOne) value - 1; 
        }
    };

    /// 按点赞数倒序，点赞数多排在前面
    public func compareDappByLike(ds1: DappStatistics, ds2: DappStatistics) : Order.Order {
        Nat.compare(ds2.likeCount, ds1.likeCount)
    };

    /// 按Id倒序，id越大表示越新，排在前面
    public func compareDappByLatest(ds1: DappStatistics, ds2: DappStatistics) : Order.Order {
        Nat.compare(ds2.profile.dappId, ds1.profile.dappId)
    };

    /// Check if User name is valid, which is defined as:
    /// 1. Between 3 and 10 characters long
    /// 2. Alphanumerical. Special characters like  '_' and '-' are also allowed.
    /// 3. must start with Alpha
    public func validUsername(name: Text): Bool {
        
        let str : [Char] = Iter.toArray(Text.toIter(name));
        if (str.size() < 3 or str.size() > 10) {
            return false;
        };

        for (i in Iter.range(0, str.size() - 1)) {
            let c = str[i];
            if (not (Char.isDigit(c) or Char.isAlphabetic(c) or (c == '_') or (c == '-'))) {
            return false;
            }
        };
        true
    };

    /// Sorts the given array according to the `cmp` function.
    /// This is a _stable_ sort.
    ///
    /// ```motoko
    /// import Array "mo:base/Array";
    /// import Nat "mo:base/Nat";
    /// let xs = [4, 2, 6, 1, 5];
    /// assert(Array.sort(xs, Nat.compare) == [1, 2, 4, 5, 6])
    /// ```
    public func sort<A>(xs : [A], cmp : (A, A) -> Order.Order) : [A] {
        let tmp : [var A] = Array.thaw(xs);
        sortInPlace(tmp, cmp);
        Array.freeze(tmp)
    };

    /// Sorts the given array in place according to the `cmp` function.
    /// This is a _stable_ sort.
    ///
    /// ```motoko
    /// import Array "mo:base/Array";
    /// import Nat "mo:base/Nat";
    /// let xs : [var Nat] = [4, 2, 6, 1, 5];
    /// xs.sortInPlace(Nat.compare);
    /// assert(Array.freeze(xs) == [1, 2, 4, 5, 6])
    /// ```
    public func sortInPlace<A>(xs : [var A], cmp : (A, A) -> Order.Order) {
        if (xs.size() < 2) return;
        let aux : [var A] = Array.tabulateVar<A>(xs.size(), func i { xs[i] });

        func merge(lo : Nat, mid : Nat, hi : Nat) {
            var i = lo;
            var j = mid + 1;
            var k = lo;

            while(k <= hi) {
                aux[k] := xs[k];
                k += 1;
            };
            k := lo;
            while(k <= hi) {
                if (i > mid) {
                    xs[k] := aux[j];
                    j += 1;
                    } else if (j > hi) {
                    xs[k] := aux[i];
                    i += 1;
                } else if (Order.isLess(cmp(aux[j], aux[i]))) {
                    xs[k] := aux[j];
                    j += 1;
                    } else {
                    xs[k] := aux[i];
                    i += 1;
                };
                k += 1;
            };
        };

        func go(lo : Nat, hi : Nat) {
            if (hi <= lo) return;

            let mid : Nat = lo + (hi - lo) / 2;
            go(lo, mid);
            go(mid + 1, hi);
            merge(lo, mid, hi);
        };
    
        go(0, xs.size() - 1);
    };

    /// Returns an `Iter` over the key-value entries of the trie.
    ///
    /// Each iterator gets a _persistent view_ of the mapping, independent of concurrent updates to the iterated map.
    public func iter<K, V>(t : Trie.Trie<K, V>) : Iter.Iter<(K, V)> {
        object {
            var stack = ?(t, null) : List.List<Trie.Trie<K, V>>;
            public func next() : ?(K, V) {
                switch stack {
                    case null { null };
                    case (?(trie, stack2)) {
                        switch trie {
                            case (#empty) {
                                stack := stack2;
                                next()
                            };
                            case (#leaf({ keyvals = null })) {
                                stack := stack2;
                                next()
                            };
                            case (#leaf({ size = c; keyvals = ?((k, v), kvs) })) {
                                stack := ?(#leaf({ size = c-1; keyvals = kvs }), stack2);
                                ?(k.key, v)
                            };
                            case (#branch(br)) {
                                stack := ?(br.left, ?(br.right, stack2));
                                next()
                            };
                        }
                    };
                }
            }
        }
    };


}