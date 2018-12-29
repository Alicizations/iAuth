<template>
  <div id="app" >
    <login @in="userLogin" @setc="setCertificationByUser" @bi="baseInfo" @verifyc="verify" @ei="extraInfo" @uia="IA" @uga="GA" @ca="userLogout"></login>
    <div v-if="status=='1'">
      <el-card class="box-card" shadow="hover">
        <div slot="header">
          <span>Hello, {{username}}</span>
          <el-button style="float: right; padding: 3px 0" type="text" @click="userLogout">Logout</el-button>
        </div>
        <div>
          <p>Public key:{{pkey}}</p>
        </div>
        <div v-if="extra=='1'">
          <p>Email:{{ content1 }}</p>
          <p>Phone:{{ content2 }}</p>
        </div>
      </el-card>
      <div style="text-align: center;">
        <el-button style="margin-top:20px; padding: 10px" @click="getEInfo" plain round>Info</el-button>
        <el-button style="margin-top:20px; padding: 10px" @click="sEInfo" plain round>Sync</el-button>
      </div>
    </div>
  </div>
</template>

<script>
import login from './components/login.vue';
export default {
  name: 'app',
  data() {
    // var status = '0';
    return {
      status:'0',
      auth:'0',
      username:'',
      content1:'',
      content2:'',
      extra:'0',
      pkey:'',
      nowUser:'',
      sAddress:'',
      sChall:''
    }
  },
  components: {
    login
  },
  mounted: function () {
    var abi = JSON.parse('[{"constant":true,"inputs":[{"name":"user","type":"address"}],"name":"getExtraInfo","outputs":[{"name":"","type":"string"},{"name":"","type":"string"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"text","type":"string"}],"name":"setCertification","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[{"name":"user","type":"address"}],"name":"userExisted","outputs":[{"name":"","type":"bool"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"_b","type":"bool"}],"name":"setExist","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"name":"_email","type":"string"},{"name":"_phone","type":"string"}],"name":"setExtraInfo","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"name":"_nickname","type":"string"},{"name":"_key","type":"string"}],"name":"setInfo","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"name":"_able","type":"bool"}],"name":"setGetable","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[{"name":"user","type":"address"}],"name":"getCertificate","outputs":[{"name":"","type":"string"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[{"name":"user","type":"address"}],"name":"getInfo","outputs":[{"name":"","type":"string"},{"name":"","type":"string"}],"payable":false,"stateMutability":"view","type":"function"}]');

    var bytecode = '608060405234801561001057600080fd5b50610baf806100206000396000f3fe6080604052600436106100985763ffffffff7c01000000000000000000000000000000000000000000000000000000006000350416634387382a811461009d5780634efa938f146101ae5780636519fac214610263578063687586f7146102aa57806393bdbf85146102d6578063a923fc4014610410578063b79846381461054a578063fd531e9314610576578063ffdd5cf11461061e575b600080fd5b3480156100a957600080fd5b506100d0600480360360208110156100c057600080fd5b5035600160a060020a0316610651565b604051808060200180602001838103835285818151815260200191508051906020019080838360005b838110156101115781810151838201526020016100f9565b50505050905090810190601f16801561013e5780820380516001836020036101000a031916815260200191505b50838103825284518152845160209182019186019080838360005b83811015610171578181015183820152602001610159565b50505050905090810190601f16801561019e5780820380516001836020036101000a031916815260200191505b5094505050505060405180910390f35b3480156101ba57600080fd5b50610261600480360360208110156101d157600080fd5b8101906020810181356401000000008111156101ec57600080fd5b8201836020820111156101fe57600080fd5b8035906020019184600183028401116401000000008311171561022057600080fd5b91908080601f0160208091040260200160405190810160405280939291908181526020018383808284376000920191909152509295506107ca945050505050565b005b34801561026f57600080fd5b506102966004803603602081101561028657600080fd5b5035600160a060020a031661080f565b604080519115158252519081900360200190f35b3480156102b657600080fd5b50610261600480360360208110156102cd57600080fd5b5035151561082d565b3480156102e257600080fd5b50610261600480360360408110156102f957600080fd5b81019060208101813564010000000081111561031457600080fd5b82018360208201111561032657600080fd5b8035906020019184600183028401116401000000008311171561034857600080fd5b91908080601f016020809104026020016040519081016040528093929190818152602001838380828437600092019190915250929594936020810193503591505064010000000081111561039b57600080fd5b8201836020820111156103ad57600080fd5b803590602001918460018302840111640100000000831117156103cf57600080fd5b91908080601f01602080910402602001604051908101604052809392919081815260200183838082843760009201919091525092955061084d945050505050565b34801561041c57600080fd5b506102616004803603604081101561043357600080fd5b81019060208101813564010000000081111561044e57600080fd5b82018360208201111561046057600080fd5b8035906020019184600183028401116401000000008311171561048257600080fd5b91908080601f01602080910402602001604051908101604052809392919081815260200183838082843760009201919091525092959493602081019350359150506401000000008111156104d557600080fd5b8201836020820111156104e757600080fd5b8035906020019184600183028401116401000000008311171561050957600080fd5b91908080601f0160208091040260200160405190810160405280939291908181526020018383808284376000920191909152509295506108c0945050505050565b34801561055657600080fd5b506102616004803603602081101561056d57600080fd5b50351515610928565b34801561058257600080fd5b506105a96004803603602081101561059957600080fd5b5035600160a060020a031661096c565b6040805160208082528351818301528351919283929083019185019080838360005b838110156105e35781810151838201526020016105cb565b50505050905090810190601f1680156106105780820380516001836020036101000a031916815260200191505b509250505060405180910390f35b34801561062a57600080fd5b506100d06004803603602081101561064157600080fd5b5035600160a060020a0316610a40565b600160a060020a038116600090815260016020819052604090912060020154606091829160ff1615151461068457600080fd5b600160a060020a0383166000908152600160208181526040928390206003810180548551600295821615610100026000190190911694909404601f8101849004840285018401909552848452936004909101929184919083018282801561072c5780601f106107015761010080835404028352916020019161072c565b820191906000526020600020905b81548152906001019060200180831161070f57829003601f168201915b5050845460408051602060026001851615610100026000190190941693909304601f8101849004840282018401909252818152959750869450925084019050828280156107ba5780601f1061078f576101008083540402835291602001916107ba565b820191906000526020600020905b81548152906001019060200180831161079d57829003601f168201915b5050505050905091509150915091565b3360009081526020819052604090205460ff1615156001146107eb57600080fd5b336000908152600260209081526040909120825161080b92840190610ae8565b5050565b600160a060020a031660009081526020819052604090205460ff1690565b336000908152602081905260409020805460ff1916911515919091179055565b3360009081526020819052604090205460ff16151560011461086e57600080fd5b336000908152600160209081526040909120835161089492600390920191850190610ae8565b5033600090815260016020908152604090912082516108bb92600490920191840190610ae8565b505050565b3360009081526020819052604090205460ff1615156001146108e157600080fd5b336000908152600160209081526040909120835161090192850190610ae8565b5033600090815260016020818152604090922083516108bb93919092019190840190610ae8565b3360009081526020819052604090205460ff16151560011461094957600080fd5b336000908152600160205260409020600201805460ff1916911515919091179055565b600160a060020a03811660009081526020819052604090205460609060ff16151560011461099957600080fd5b600160a060020a038216600090815260026020818152604092839020805484516001821615610100026000190190911693909304601f8101839004830284018301909452838352919290830182828015610a345780601f10610a0957610100808354040283529160200191610a34565b820191906000526020600020905b815481529060010190602001808311610a1757829003601f168201915b50505050509050919050565b600160a060020a038116600090815260208190526040902054606090819060ff161515600114610a6f57600080fd5b600160a060020a03831660009081526001602081815260409283902080548451601f6002600019610100858916150201909316929092049182018490048402810184019095528085529093928401929184919083018282801561072c5780601f106107015761010080835404028352916020019161072c565b828054600181600116156101000203166002900490600052602060002090601f016020900481019282601f10610b2957805160ff1916838001178555610b56565b82800160010185558215610b56579182015b82811115610b56578251825591602001919060010190610b3b565b50610b62929150610b66565b5090565b610b8091905b80821115610b625760008155600101610b6c565b9056fea165627a7a72305820fe5807674d4bbe24ed9e572bbfaacf63385aa8c1548bb8dc15f4ec816ed2b7bc0029';

    setTimeout(function () {
      var nameContract = web3.eth.contract(abi);
      var Cuser = web3.eth.accounts[0];
      console.log(Cuser);
      this.auth = nameContract.new(null, null, {
        from:Cuser,
        data:bytecode,
        gas:'1040000'}, function(err, myContract) {
        if(!err) {
          if(!myContract.address) {
            console.log(myContract.transactionHash)
          } else {
            console.log(myContract.address)
          }
        }
      });
    }, 500);
    
  },
  methods: {
    userLogin() {
      this.status = '1';
    },
    userLogout() {
      this.status = '0';
      this.extra = '0';
      this.username = '';
      this.pkey = '';
      this.content1 = '';
      this.content2 = '';
      this.nowUser = '';
      this.sAddress = '';
      this.sChall = '';
    },
    setCertificationByUser(data) {
      auth.setCertification.sendTransaction(data.ct, {from:data.u}, 
        (e, r)=> {
          if (!e) {
            this.$message({
              message: 'success',
              type: 'success'
            });
          } else {
            this.$message.error('Set Certification fail');
          }
      });
    },
    baseInfo(data) {
      auth.setInfo.sendTransaction(data.nname, data.pkey, {from:data.u},
        (e, r)=>{
          if (!e) {
            this.$message({
              message: 'success',
              type: 'success'
            });
          } else {
            this.$message.error('Set base information fail');
          }
      });
    },
    verify(data) {
      auth.getCertificate(data.u, (e,r)=> {
        if (r == data.ct) {
          this.nowUser = data.u;
          this.userLogin();
          this.$message({
            message: 'Verify successfully',
            type: 'success'
          });
          auth.getInfo(data.u, (e, r)=>{
            if (!e) {
              this.$message({
                message: 'success',
                type: 'success'
              });
              this.username = r[0];
              this.pkey = r[1];
              if (this.username == '') {
                this.username = 'ANONYMOUS';
              }
              if (this.pkey == '') {
                this.pkey = 'NO SETTING';
              }
            } else {
              this.$message.error('Get information fail');
            }
          });
        } else {
          this.$message.error('Verify fail');
        }
      });
    },
    extraInfo(data) {
      auth.setExtraInfo.sendTransaction(data.eemail, data.ephone, {from:data.u},
        (e, r)=>{
          if (!e) {
            this.$message({
              message: 'success',
              type: 'success'
            });
          } else {
            this.$message.error('Set extra information fail');
          }
      });
    },
    getEInfo() {
      console.log(this.nowUser);
      auth.getExtraInfo(this.nowUser, (e, r)=>{
        if (!e) {
          this.content1 = r[0];
          this.content2 = r[1];
          if (this.content1 == '') {
            this.content1 = 'NO SETTING';
          }
          if (this.content2 == '') {
            this.content2 = 'NO SETTING';
          }
          this.$message({
            message: 'Get extra information successfully',
            type: 'success'
          });
          this.extra = '1';
        } else {
          this.$message.error('Get extra information fail');
        }
      });
    },
    IA(data) {
      auth.setExist.sendTransaction(data.exist, {from:data.u}, 
        (e, r)=> {
          if (!e) {
            data.cb(data.exist);
          } else {
            data.cb(!data.exist);
          }
      });
    },
    GA(data) {
      auth.setGetable.sendTransaction(data.ga, {from:data.u}, 
        (e, r)=> {
          if (!e) {
            data.cb(data.ga);
          } else {
            data.cb(!data.ga);
          }
      });
    },
    sEInfo() {
      const h = this.$createElement;
      this.$msgbox({
        title: 'Sync extra information',
        message: h('div', null, [
          h('el-input', {
            attrs:{
              id:'ksa',
              placeholder:'Address',
              clearable:''
            }
          }, null), 
          h('el-input', {
            attrs:{
              id:'ksc',
              placeholder:'Challenge',
              clearable:''
            }
        }, null)]),
        confirmButtonText: 'verify',
        beforeClose: (action, instance, done) => {
          if (action === 'confirm') {
            this.sAddress = document.getElementById('ksa')._value;
            this.sChall = document.getElementById('ksc')._value;
            console.log(this.sAddress,'++',this.sChall);
            instance.confirmButtonLoading = true;
            instance.confirmButtonText = 'loading...';
            auth.getCertificate(this.sAddress, (e, r)=>{
              if (!e && r == this.sChall) {
                auth.getExtraInfo(this.sAddress, (e2, r2)=>{
                  if (!e2) {
                    this.content1 = r2[0];
                    this.content2 = r2[1];
                    this.$message({
                      message: 'Sync successfully',
                      type: 'success'
                    });
                    this.extra = '1';
                  } else {
                    this.$message.error('Sync fail');
                  }
                  instance.confirmButtonLoading = false;
                  done();
                });
              } else {
                this.$message.error('Sync fail');
                instance.confirmButtonLoading = false;
                done();
              }
            });
          } else {
            instance.confirmButtonLoading = false;
            done();
          }
        }
      }).catch(cancel => {});
    }
  }
}
</script>

<style>
#app {
  font-family: 'Avenir', Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  color: #2c3e50;
  margin-top: 60px;
}
.box-card {
  width: 320px;
  margin-left: auto;
  margin-right: auto;
  margin-top: 50px;
}
</style>
