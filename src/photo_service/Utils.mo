
import AssocList "mo:base/AssocList";
import Hash "mo:base/Hash";
import HashMap "mo:base/HashMap";
import Text "mo:base/Text";
import Trie "mo:base/Trie";

import Types "./Types";

module {

    type PictureEditReq = Types.PictureEditReq;
    type PictureId = Types.PictureId;
    type PictureInfo = Types.PictureInfo;
    type PictureStatus = Types.PictureStatus;
    type StablePictureMap = Types.StablePictureMap;

    type UserId = Types.UserId;

    /// 辅助方法 把外部请求的修改图片数据转成PictureInfo格式,其中图片状态文本格式需要转换
    /// Args:
    ///     |req|   带图片数据的请求
    ///     |editer|    编辑图片的操作者
    ///     |editTime|  编辑图片的时间
    /// Returns:
    ///     转换成功后的PictureInfo
    public func editReqToPictureInfo(
        req: PictureEditReq,
        editer: UserId,
        editTime: Int
        ) : PictureInfo {
            {
                picId = req.picId;
                pic = req.pic;
                picBin = req.picBin;
                picName = req.picName;
                description = req.description;
                owner = req.owner;
                status = textToPictureStatus(req.status);
                createdAt = editTime;
                createdBy = editer
            }
        };

    /// 辅助方法 把文本转换为PictureStatus
    /// Args:
    ///     |text_status|   需要转成PictureStatus枚举的文本: enable, disable, pending
    /// Returns:
    ///     返回文本对应的PictureStatus定义的枚举，enable -> #enable, disable -> #disable, _ -> #pending
    public func textToPictureStatus(text_status: Text) : PictureStatus {
        if (text_status == "enable") {
            #enable
        } else if (text_status == "disable") {
            #disable
        } else {
            #pending
        }
    };

    /// 辅助方法,判断两张图片信息是否一致
    public func pictureEq(lhs: PictureId, rhs: PictureId) : Bool {
        lhs == rhs
    };

    public func pictureMapFilterFn(picId: PictureId, picInfo: PictureInfo) : ?PictureId {
        ?picId
    };

    /// 辅助方法 Nat + 1
    public func incrementOne(value: Nat): Nat {
        value + 1
    };

    /// 辅助方法 Nat - 1
    public func decrementOne(value: Nat): Nat {
        value - 1
    };

    /// 辅助方法 过滤HashMap中不符合条件的数据,不修改原业的数据,返回新数据
    public func filterValues<K, V>(
        hm: HashMap.HashMap<K, V>,
        keyEq : (K, K) -> Bool,
        keyHash : K -> Hash.Hash,
        f: V -> Bool): HashMap.HashMap<K, V> {

        let res = HashMap.HashMap<K, V>(1, keyEq, keyHash);
        
        for ((k, v) in hm.entries()) {
            if (f(v)) {
                res.put(k, v)
            }
        };

        res
    };

    /// 辅助方法，Trie.find方法乃至的Trie.Key实例
    public func keyOfPicture(picId: PictureId): Trie.Key<PictureId> {
        { key = picId; hash = Hash.hash(picId) }
    };


};