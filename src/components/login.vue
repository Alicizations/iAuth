<template>
  <el-tabs v-model="active" type="card" id="place"
  background-color="#545c64"
  text-color="#fff"
  active-text-color="#ffd04b">
    <el-tab-pane label="Google" name="first">
      <el-input v-model="username" readonly>
        <template slot="prepend">Address</template>
      </el-input>
      <el-input style="margin-top: 10px;" v-model="ctext" readonly>
        <template slot="prepend">Challenge</template>
      </el-input>
      <div style="text-align: center;margin-top: 10px;">
        <el-button size="small" round @click="getAccountAndC">Get</el-button>
        <el-button size="small" type="primary" round plain @click="open">Verify</el-button>
      </div>
    </el-tab-pane>
    <el-tab-pane label="iAuth工具" name="second">
      <el-tabs :tab-position="'left'" >
        <el-tab-pane label="控制台">
          <el-switch
            style="margin-top: 30px;margin-left: 80px;"
            v-model="radio"
            active-color="#13ce66"
            active-text="启用iAuth"
            @change="useIA">
          </el-switch>
          <br/>
          <el-switch
            style="margin-top: 30px;margin-left: 80px;"
            v-model="eradio"
            active-color="#13ce66"
            active-text="启用Extra"
            @change="useGA">
          </el-switch>
        </el-tab-pane>
        <el-tab-pane label="基本信息">
          <el-input 
            v-model="nikename"
            placeholder="nikename"
            clearable>
          </el-input>
          <el-input 
            style="margin-top: 10px;"
            v-model="publicKey"
            placeholder="public key"
            type="textarea"
            :rows="5"
            clearable>
          </el-input>
          <div style="text-align: center;margin-top: 10px;">
            <el-button size="small" type="primary" plain round @click="baseI">Send</el-button>
          </div>
        </el-tab-pane>
        <el-tab-pane label="额外信息">
          <el-input 
            style="margin-top: 40px;"
            v-model="uemail"
            placeholder="email"
            clearable>
          </el-input>
          <el-input 
            style="margin-top: 10px;"
            v-model="uphone"
            placeholder="phone"
            clearable>
          </el-input>
          <div style="text-align: center;margin-top: 10px;">
            <el-button size="small" type="primary" plain round @click="extraI">Send</el-button>
          </div>
        </el-tab-pane>
        <el-tab-pane label="验证密文">
          <el-input 
            v-model="ctext"
            placeholder="challenge"
            readonly>
          </el-input>
          <el-input 
            style="margin-top: 10px;"
            placeholder="private key"
            type="textarea"
            :rows="5"
            clearable>
          </el-input>
          <div style="text-align: center;margin-top: 10px;">
            <el-button size="small" type="primary" plain round @click="encry">Send</el-button>
            <el-tooltip class="item" effect="dark" content="将挑战经过私钥加密后写入区块链" placement="right">
              <i class="el-icon-question"></i>
            </el-tooltip>
          </div>
        </el-tab-pane>
      </el-tabs>
    </el-tab-pane>
  </el-tabs>
</template>
<script>
  export default {
    data() {
      return {
        active: 'first',
        username: '',
        ctext: '',
        radio:false,
        eradio:false,
        nikename:'',
        publicKey:'',
        uemail:'',
        uphone:''
      };
    },
    methods: {
      open() {
        this.$emit("verifyc", {u:this.username,ct:this.ctext});
      },
      randomWord(randomFlag, min, max) {
        let str = "", pos = 0,
          range = min,
          arr = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9',
            'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l',
            'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z',
            'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L',
            'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z',
            '-','.','~','!','@','#','$','%','^','&','*','(',')','_',':','<','>','?'];

        if (randomFlag) {
          range = Math.round(Math.random() * (max - min)) + min;
        }
        for (let i = 0; i < range; i++) {
          pos = Math.round(Math.random() * (arr.length - 1));
          str += arr[pos];
        }
        return str;
      },
      getAccountAndC() {
        var temp = web3.eth.accounts[0];
        if (temp != this.username && this.username != '') {
          this.$emit("ca", null);
          this.radio = false;
          this.eradio = false;
          this.nikename = '';
          this.publicKey = '';
          this.uemail = '';
          this.uphone = '';
        }
        this.username = temp;
        this.ctext = this.randomWord(true, 6, 12);
      },
      encry() {
        this.$emit("setc", {u:this.username,ct:this.ctext,cb:function (e, res) {
          console.log(e, res);
        }});
      },
      baseI() {
        this.$emit("bi", {
          u:this.username,
          nname:this.nikename,
          pkey:this.publicKey
        });
      },
      useIA() {
        this.$emit("uia", {
          u:this.username,
          exist:this.radio,
          cb:(flag)=>{
            if (flag) {
              this.radio = true;
            } else {
              this.radio = false;
            }
          }
        });
      },
      useGA() {
        this.$emit("uga", {
          u:this.username,
          ga:this.eradio,
          cb:(flag)=>{
            if (flag) {
              this.eradio = true;
            } else {
              this.eradio = false;
            }
          }
        });
      },
      extraI() {
        this.$emit("ei", {
          u:this.username,
          eemail:this.uemail,
          ephone:this.uphone
        });
      }
    }
  };
</script>

<style>
  #place {
    width: 400px;
    margin-left: auto;
    margin-right: auto;
    margin-top: 10%;
  }
</style>