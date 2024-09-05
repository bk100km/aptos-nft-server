module 0x123456789abcdef::MonsterNFT {
    use std::signer;
    use std::vector;

    struct MonsterNFT has key, store {
        id: u64,
        name: vector<u8>,       // Name of the monster
        attributes: vector<u8>, // Attributes of the monster
        owner: address,         // Address of the NFT owner
    }

    struct Collection has key {
        owner: address,
        monsters: vector<MonsterNFT>,
    }

    // Creates a monster NFT collection for the owner
    public fun init_collection(account: &signer) {
        let collection = Collection {
            owner: signer::address_of(account),
            monsters: vector::empty<MonsterNFT>(),
        };
        move_to(account, collection);
    }

    // Mints a new monster NFT upon collection
    public fun mint_monster(account: &signer, id: u64, name: vector<u8>, attributes: vector<u8>) acquires Collection {
        let collection = borrow_global_mut<Collection>(signer::address_of(account));

        // Creates a new monster NFT
        let monster_nft = MonsterNFT {
            id,
            name,
            attributes,
            owner: signer::address_of(account),
        };

        vector::push_back(&mut collection.monsters, monster_nft);
    }

    // Retrieves a copied list of NFTs owned by the account
    public fun get_monsters(account: &signer): vector<MonsterNFT> acquires Collection {
        let collection = borrow_global<Collection>(signer::address_of(account));

        // Create an empty vector to store the copied monsters
        let monsters_copy = vector::empty<MonsterNFT>();

        // Iterate over the original vector and push copies to the new vector
        let len = vector::length(&collection.monsters);
        let i = 0;
        while (i < len) {
            let monster = vector::borrow(&collection.monsters, i);
            vector::push_back(&monsters_copy, *monster);
            i = i + 1;
        };

        monsters_copy
    }
}
