
import Debug "mo:base/Debug";
import Hash "mo:base/Hash";
import List "mo:base/List";
import Nat "mo:base/Nat";
import Principal "mo:base/Principal";
import Text "mo:base/Text";
import Time "mo:base/Time";
import Trie "mo:base/Trie";

import Types "./Types";

/// 通用的操纵数据集的模块，包括插入/更新，查询，删除，分页等功能
module {
    
    type Page<X> = Types.Page<X>;

    type Database<K, V> = Types.Database<K, V>;
    type DBKey<K> = Types.DBKey<K>;
    

    public class Repository<K, V>() {
        
        /// 根据id查询，如果对应的id存在，返回?V，否则返回null
        public func get(db: Database<K, V>, kk: DBKey<K>, k_eq : (K, K) -> Bool) : ?V {
            Trie.find<K, V>(db, kk, k_eq)
            
        };

        /// 根据过滤条件查询，返回符合条件的数据集
        public func findBy(db: Database<K, V>, f: (K, V) -> Bool): Database<K, V> {
            let entities = Trie.filter<K, V>(db, f);
            entities
        };

        /// 根据过滤条件统计数量，返回满足条件的记录数，否则返回0
        public func countBy(db: Database<K, V>, f: (K, V) -> Bool) : Nat {       
            Trie.size<K, V>(findBy(db,f))
        };

        /// 通过指定的id和数据，更新数据集，返回更新后的数据集和旧数据（如果对应的id不存在，旧数据返回null）
        public func update(db: Database<K, V>, v: V, kk: DBKey<K>, k_eq : (K, K) -> Bool) : (Database<K, V>, ?V) {
            Trie.put<K, V>(db, kk, k_eq, v);
        };

        /// 从数据集中删除指定的记录，返回删除指定记录的数据集和被删除的记录（如果id对应的记录存在，否则返回null）
        public func delete(db: Database<K, V>, kk: DBKey<K>, k_eq : (K, K) -> Bool) : (Database<K, V>, ?V) {
            let res = Trie.remove<K, V>(db, kk, k_eq);
            res
        };

        /// 分页处理封装
        /// Args：
        ///     |dba|   需要处理的数据集
        ///     |pageSize|  每页记录数
        ///     |pageNum|   页码，0表示第一页
        /// Returns:
        ///     返回封装好的分页数据格式
        public func page(dba: [V], pageSize: Nat, pageNum: Nat) : Page<V> {
            let skipCounter = pageNum * pageSize;

            let dataList = List.fromArray<V>(dba);
            
            let remainning = List.drop<V>(dataList, skipCounter);
            let paging = List.take<V>(remainning, pageSize);

            {
                data = List.toArray<V>(paging);
                pageSize = pageSize;
                pageNum = pageNum;
            }
        };
    };

    
};