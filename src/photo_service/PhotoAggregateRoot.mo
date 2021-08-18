
import AssocList "mo:base/AssocList";
import Debug "mo:base/Debug";
import HashMap "mo:base/HashMap";
import List "mo:base/List";
import Nat "mo:base/Nat";
import Option "mo:base/Option";
import Principal "mo:base/Principal";
import Result "mo:base/Result";
import Time "mo:base/Time";
import Text "mo:base/Text";
import Trie "mo:base/Trie";
import TrieMap "mo:base/TrieMap";

import PictureRepository "./PictureRepository";
import Types "./Types";
import Utils "./Utils";

actor PhotoAggregateRoot {

    type PictureId = Types.PictureId;
    type Picture = Types.Picture;
    type PictureBin = Types.PictureBin;
    type PictureInfo = Types.PictureInfo;
    type PicturePage = Types.PicturePage;

    type UserId = Types.UserId;

    type Error = Types.PicError;

    type Result<V, E> = Result.Result<V, E>;
    
    // 图片器，也是图片ID生成器
    stable var idSequence = 0;

    // stable var totalPics: Nat = 0;

    // stable var stablePics: AssocList.AssocList<PictureId, PictureInfo> = List.nil<(PictureId, PictureInfo)>();

    stable var stablePics: Trie.Trie<PictureId, PictureInfo> = Trie.empty<PictureId, PictureInfo>();

    var pictureRepository : PictureRepository.PictureRepository = PictureRepository.PictureRepository();

    /// -------------- query ------------- ///

    /// 查询图片总数
    public query func getTotalPics() : async Nat {
        Trie.size<PictureId, PictureInfo>(stablePics)
    };

    /// 获取图片() 公共的获取图片的接口
    /// Args:
    ///     |picId|  需要获取图片的id
    /// Returns:
    ///     如果对应id的图片存在，返回对应的图片信息，否则返回null
    public query func getPic(picId: PictureId): async ?PictureInfo {
        pictureRepository.getPic(stablePics, picId)
    };

    public query func getPic2(picId: PictureId): async PictureInfo {
        Option.unwrap<PictureInfo>(pictureRepository.getPic(stablePics, picId))
    };

    /// Retrieves the |owner|'s totalPicSize
    /// Args:
    ///     |owner| 被查询的图片所有者 
    /// Returns:
    ///     被查询用户保存的所有图片的数量
    public query func getTotalPicsByOwner(owner: UserId) : async Result<Nat, Error> {
        let countPics= pictureRepository.countPicsByOwner(stablePics, owner);
        #ok(countPics)
    };


    /// Retrieves the |owner|'s 所有图片，需要分页优化 FIXME
    /// Args:
    ///     |owner| 被查询的图片所有者 
    /// Returns:
    ///     被查询用户保存的所有图片列表
    public query func getPicsByOwner(owner: UserId) : async [PictureInfo] {
        let picsMap = pictureRepository.findPicsByOwner(stablePics, owner);
        Trie.toArray<PictureId, PictureInfo, PictureInfo>(picsMap, func (id: PictureId, info: PictureInfo) : PictureInfo {
            info
        })
    };

    /// Retrieves the |owner|'s 图片分页查询
    /// Args:
    ///     |owner| 被查询的图片所有者 
    /// Returns:
    ///     被查询用户保存的所有图片列表
    public query func pagePicsByOwner(owner: UserId, pageSize: Nat, pageNum: Nat) : async PicturePage {
        let picsMap = pictureRepository.findPicsByOwner(stablePics, owner);
        let picsArr = Trie.toArray<PictureId, PictureInfo, PictureInfo>(picsMap, func (id: PictureId, info: PictureInfo) : PictureInfo {
            info
        });

        let skipCounter = pageNum * pageSize;

        let picsList = List.fromArray<PictureInfo>(picsArr);

        let remainning = List.drop<PictureInfo>(picsList, skipCounter);
        let paging = List.take<PictureInfo>(remainning, pageSize);
        {
            data = List.toArray<PictureInfo>(paging);
            pageSize = pageSize;
            pageNum = pageNum;
        }
        
    };

    /// -------------- Update --------------------- ///

    /// createPic() 公共的上传图片接口 需要和前端确认数据格式,图片状态默认是enable
    /// Args:
    ///     |pic|   上传时需要保存的图片内容
    ///     |owner| 图片的所有者
    ///     |picName|   图片的名称
    ///     |description|   对图片的描述
    /// Returns:
    ///     处理成功返回#ok(图片id),,否则返回相应错误
    public shared(msg) func createPic(pic: Picture, picBin: PictureBin, picName: Text, description: Text, owner: UserId) : async Result<PictureId, Error> {
        let picId = idSequence;
        
        // 图片id递增
        idSequence := Utils.incrementOne(idSequence);
        //totalPics := Utils.incrementOne(totalPics);

        let current_time = Time.now();
        let createdBy = Principal.toText(msg.caller);
        let picInfo: PictureInfo = {
            picId = picId;
            pic = pic;
            picBin = picBin;
            picName = picName;
            description = description;
            owner = owner;
            status = #enable;
            createdBy = createdBy;
            createdAt = current_time;
        };

        let picOpt = pictureRepository.getPic(stablePics, picId);

        switch (picOpt) {
            case (?_) #err(#picAlreadyExisted);
            case null {
                let (newPics, _) = pictureRepository.updatePic(stablePics, picInfo);
                stablePics := newPics;

                #ok(picId)
            };
        }
        
    };

    public shared(msg) func createPicNoBin(pic: Picture, picName: Text, description: Text, owner: UserId) : async Result<PictureId, Error> {
        let picId = idSequence;
        
        // 图片id递增
        idSequence := Utils.incrementOne(idSequence);
        //totalPics := Utils.incrementOne(totalPics);

        let current_time = Time.now();
        let createdBy = Principal.toText(msg.caller);
        let picInfo: PictureInfo = {
            picId = picId;
            pic = pic;
            picBin = [];
            picName = picName;
            description = description;
            owner = owner;
            status = #enable;
            createdBy = createdBy;
            createdAt = current_time;
        };

        let picOpt = pictureRepository.getPic(stablePics, picId);

        switch (picOpt) {
            case (?_) #err(#picAlreadyExisted);
            case null {
                let (newPics, _) = pictureRepository.updatePic(stablePics, picInfo);
                stablePics := newPics;

                #ok(picId)
            };
        }
        
    };

    public shared(msg) func createPic2(pic: Picture, picBin: PictureBin, picName: Text, description: Text, owner: UserId) : async PictureId {
        let picId = idSequence;
        
        // 图片id递增
        idSequence := Utils.incrementOne(idSequence);
        //totalPics := Utils.incrementOne(totalPics);

        let current_time = Time.now();
        let createdBy = Principal.toText(msg.caller);
        let picInfo: PictureInfo = {
            picId = picId;
            pic = pic;
            picBin = picBin;
            picName = picName;
            description = description;
            owner = owner;
            status = #enable;
            createdBy = createdBy;
            createdAt = current_time;
        };

        let picOpt = pictureRepository.getPic(stablePics, picId);

        let (newPics, _) = pictureRepository.updatePic(stablePics, picInfo);
        stablePics := newPics;
        
        picId
        
    };

    public shared(msg) func createPic2NoBin(pic: Picture, picName: Text, description: Text, owner: UserId) : async PictureId {
        let picId = idSequence;
        
        // 图片id递增
        idSequence := Utils.incrementOne(idSequence);
        //totalPics := Utils.incrementOne(totalPics);

        let current_time = Time.now();
        let createdBy = Principal.toText(msg.caller);
        let picInfo: PictureInfo = {
            picId = picId;
            pic = pic;
            picBin = [];
            picName = picName;
            description = description;
            owner = owner;
            status = #enable;
            createdBy = createdBy;
            createdAt = current_time;
        };

        let picOpt = pictureRepository.getPic(stablePics, picId);

        let (newPics, _) = pictureRepository.updatePic(stablePics, picInfo);
        stablePics := newPics;
        
        picId
        
    };

    /// editPic() 公共的编辑图片接口 需要和前端确认数据格式
    /// Args:
    ///     |picId|    需要修改的图片id
    ///     |pic|  需要修改的图片
    ///     |picBin|    需要修改的图片二进制格式
    ///     |picName|   需要修改的图片名称
    ///     |description|   需要修改的图片描述
    ///     |owner|     需要修改的图片所有者
    ///     |status|    需要修改的图片状态，enable, disable or pending
    /// Returns:
    ///     处理成功返回#ok(PictureInfo),出错返回相应错误
    public shared(msg) func editPic(
        picId: PictureId,
        pic: Picture, 
        picBin: PictureBin,
        picName: Text,  
        description: Text, 
        owner: UserId,
        status: Text) : async Result<PictureInfo, Error> {
        
        let current_time = Time.now();
        let createdBy = Principal.toText(msg.caller);
        let newStatus = Utils.textToPictureStatus(status);

        let picInfo: PictureInfo = {
            picId = picId;
            pic = pic;
            picBin = picBin;
            picName = picName;
            description = description;
            owner = owner;
            status = newStatus;
            createdBy = createdBy;
            createdAt = current_time;
        };

        let (newPics, _) = pictureRepository.updatePic(stablePics, picInfo);

        stablePics := newPics;

        #ok(picInfo)
            
    };

    public shared(msg) func editPic2(
        picId: PictureId,
        pic: Picture, 
        picBin: PictureBin,
        picName: Text,  
        description: Text, 
        owner: UserId,
        status: Text) : async PictureInfo {
        
        let current_time = Time.now();
        let createdBy = Principal.toText(msg.caller);
        let newStatus = Utils.textToPictureStatus(status);

        let picInfo: PictureInfo = {
            picId = picId;
            pic = pic;
            picBin = picBin;
            picName = picName;
            description = description;
            owner = owner;
            status = newStatus;
            createdBy = createdBy;
            createdAt = current_time;
        };

        let (newPics, _) = pictureRepository.updatePic(stablePics, picInfo);
        stablePics := newPics;

        picInfo
            
    };

    public shared(msg) func editPicNoBin(
        picId: PictureId,
        pic: Picture, 
        picName: Text,  
        description: Text, 
        owner: UserId,
        status: Text) : async Result<PictureInfo, Error> {
        
        let current_time = Time.now();
        let createdBy = Principal.toText(msg.caller);
        let newStatus = Utils.textToPictureStatus(status);

        let picInfo: PictureInfo = {
            picId = picId;
            pic = pic;
            picBin = [];
            picName = picName;
            description = description;
            owner = owner;
            status = newStatus;
            createdBy = createdBy;
            createdAt = current_time;
        };

        let (newPics, _) = pictureRepository.updatePic(stablePics, picInfo);

        stablePics := newPics;

        #ok(picInfo)
            
    };

    public shared(msg) func editPic2NoBin(
        picId: PictureId,
        pic: Picture, 
        picName: Text,  
        description: Text, 
        owner: UserId,
        status: Text) : async PictureInfo {
        
        let current_time = Time.now();
        let createdBy = Principal.toText(msg.caller);
        let newStatus = Utils.textToPictureStatus(status);

        let picInfo: PictureInfo = {
            picId = picId;
            pic = pic;
            picBin = [];
            picName = picName;
            description = description;
            owner = owner;
            status = newStatus;
            createdBy = createdBy;
            createdAt = current_time;
        };

        let (newPics, _) = pictureRepository.updatePic(stablePics, picInfo);
        stablePics := newPics;

        picInfo
            
    };
    

    /// deletePic() 公共的删除图片接口 需要和前端确认数据格式
    /// Args:
    ///     |picId|    需要修改的图片数据
    /// Returns:
    ///     删除成功返回对应图片id的图片信息的#ok(PictureInfo),出错返回相应错误
    public shared(msg) func deletePic(picId: PictureId) : async Result<PictureInfo, Error> {
        let (newPics, deletedPic) = pictureRepository.deletePic(stablePics, picId);
        stablePics := newPics;

        Debug.print("pic id: " # Nat.toText(picId) # " already deleted!");

        switch (deletedPic) {
            case (?picInfo) {
                
                #ok(picInfo)
            };
            case _ #err(#picNotFound);
        }
    
    };

    public shared(msg) func deletePic2(picId: PictureId) : async PictureInfo {
        let (newPics, deletedPic) = pictureRepository.deletePic(stablePics, picId);
        stablePics := newPics;

        Debug.print("pic id: " # Nat.toText(picId) # " already deleted!");

        Option.unwrap<PictureInfo>(deletedPic)
    
    };

    
    /// Test method 测试保存数据,并读取
    public shared(msg) func testCreateAndGet() {
        let pic: Text = "23dsfdsdfadsdsdfd80sfsfsds";
        let picBin: [Nat8] = [2,2,2,1,2,3];
        let owner = "James";
        let description = "Test pic";
        let picName = "James Photo";

        let picIdRes = await createPic(pic, picBin, picName, description, owner);
        
        assert(Result.isOk(picIdRes));

        switch (picIdRes) {
            case (#ok(picId)) {
                Debug.print("The pic id: " # Nat.toText(picId));
                let  picInfo = await getPic(picId);

                assert(Option.isSome(picInfo));

                switch (picInfo) {
                    case (?info) {
                        assert info.owner == owner;
                        assert info.description == description;
                        assert info.picName == picName;
                        assert info.pic == pic;
                    };
                    case (_) {
                        Debug.print("Get Pic " # Nat.toText(picId) # " happen error " );
                        assert false;                  
                    };

                }
            };
            case (#err(_)) {
                Debug.print("Create Pic happen error ");
                        assert false; 
            };
        }
    };
};
