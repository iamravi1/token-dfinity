import Principal "mo:base/Principal";
import HashMap "mo:base/HashMap";
import Debug "mo:base/Debug";
import Iter "mo:base/Iter";

actor Token {
    var owner : Principal = Principal.fromText("xxjvs-3kyvu-u3d5v-cnzvo-ng7se-qv5qx-mnxq6-3umig-pipvj-tqt3p-yae");
    var totalSupply : Nat = 1000000000;
    var symbol : Text = "TERA";

    private stable var balanceEntries : [(Principal,Nat)] = [];

    private var balences = HashMap.HashMap<Principal, Nat>(1, Principal.equal, Principal.hash);

        if(balences.size() < 1){
            balences.put(owner, totalSupply);                                                   
        };

    public query func balanceOf(who: Principal) : async Nat {
        let balence : Nat = switch (balences.get(who)){
            case null 0;
            case (?result) result;
        };
        return balence;
    };

    public query func getSymbol(): async Text {
        return symbol;
    };

    public shared(msg) func payOut(): async Text {

        if(balences.get(msg.caller) == null){
            let amount = 10000;
            let result = await transfer(msg.caller,amount);
            return result;
        }else{
            return "Already Claimed";
        }
    };

    public shared(msg) func transfer(to: Principal, amount: Nat) : async Text{
        let fromBalance = await balanceOf(msg.caller);

        if(fromBalance > amount){
            let newBalance : Nat = fromBalance - amount;
            balences.put(msg.caller,newBalance);

            let toBalance = await balanceOf(to);
            let newToBalance = toBalance + amount;
            balences.put(to,newToBalance);

            return "Success";
            
        }else{
            return "Incufficient Funds";
        }
    };

    system func preupgrade(){
        balanceEntries := Iter.toArray(balences.entries());
    };

    system func postupgrade(){
        balences := HashMap.fromIter<Principal,Nat>(balanceEntries.vals(), 1, Principal.equal, Principal.hash);
        if(balences.size() < 1){
            balences.put(owner, totalSupply);                                                   
        }
    };
};