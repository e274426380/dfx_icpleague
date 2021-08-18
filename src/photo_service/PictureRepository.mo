

import Hash "mo:base/Hash";
import Nat "mo:base/Nat";
import Principal "mo:base/Principal";
import Text "mo:base/Text";
import Time "mo:base/Time";
import Trie "mo:base/Trie";

import Types "./Types";
import Utils "./Utils";


module {
    type PictureId = Types.PictureId;
    type PictureInfo = Types.PictureInfo;
    type StablePictureMap = Types.StablePictureMap;

    type UserId = Types.UserId;

    
    public class PictureRepository() {
        
        public func getPic(pics: StablePictureMap, picId: PictureId) : ?PictureInfo {
            Trie.find<PictureId, PictureInfo>(pics, Utils.keyOfPicture(picId), Nat.equal)
            
        };

        public func findPicsByOwner(pics: StablePictureMap, owner: UserId): StablePictureMap {
            let picsByOwner = Trie.filter<PictureId, PictureInfo>(pics, func (k, v) {
                v.owner == owner
            });
            picsByOwner
        };

        public func countPicsByOwner(pics: StablePictureMap, owner: UserId): Nat {       
            Trie.size<PictureId, PictureInfo>(findPicsByOwner(pics, owner))
        };

        public func updatePic(pics: StablePictureMap, picInfo: PictureInfo) : (StablePictureMap, ?PictureInfo) {
            Trie.put<PictureId, PictureInfo>(pics, Utils.keyOfPicture(picInfo.picId), Nat.equal, picInfo);
        };

        public func deletePic(pics: StablePictureMap, picId: PictureId) : (StablePictureMap, ?PictureInfo) {
            let res = Trie.remove<PictureId, PictureInfo>(pics, Utils.keyOfPicture(picId), Nat.equal);
            res
        };
    };
    
};