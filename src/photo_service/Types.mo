/// Types.mo
/// Public types.

import HashMap "mo:base/HashMap";
import AssocList "mo:base/AssocList";
import Trie "mo:base/Trie";

module {
    public type Picture = Text;  
    public type PictureBin = [Nat8];  
    public type Timestamp = Int;    // See mo:base/Time and Time.now()
    public type PictureId = Nat;
    public type UserId = Text;
    // public type PictureMap = HashMap.HashMap<PictureId, PictureInfo>;
    public type StablePictureMap = Trie.Trie<PictureId, PictureInfo>;
    // public type StablePictureMap = AssocList.AssocList<PictureId, PictureInfo>;
    
    public type PictureKey = Trie.Key<PictureId>;

    /// 对图片信息分页表示
    public type PicturePage = Page<PictureInfo>;

    /// 图片的基本信息
    public type PictureInfo = {
        picId : PictureId;
        pic:  Picture;
        picBin: PictureBin;
        picName: Text;
        description: Text;
        owner: UserId;
        status: PictureStatus;
        createdBy: UserId;
        createdAt: Timestamp;
    };

    public type PictureStatus = {
        #enable;
        #disable;
        #pending;
    };

    
    public type PicError = {
        #picNotFound;
        #picAlreadyExisted;
    };

    /// 外部请求数据
    public type PictureEditReq = {
        picId: Nat;
        pic: Picture;
        picBin: PictureBin;
        picName: Text;
        description: Text;
        owner: Text;
        status: Text;
    };

    public type Page<T> = {
        data : [T];
        pageSize : Nat;
        pageNum : Nat;
    };
};