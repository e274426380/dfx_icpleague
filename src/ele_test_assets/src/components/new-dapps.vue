<template>
  <!--card padding设置为0，让里面的元素能自行构建-->
  <el-card class="box-card" style="padding: 0">
    <el-row style="
    background-color: rgba(234, 238, 246, 0.4);
                                padding:0 50px;">
      <el-row>
        <div class="subtitle">
          <!--<b>{{$t('button.dapps')}}</b>-->
          <b>Dapps</b>
          <!--以页码的形式展示-->
          <!--<el-button type="danger" round @click="toPage(index)"-->
          <!--:class="{active:index==currentPage}"-->
          <!--v-for="(item, index) in pageNum"-->
          <!--:key="index">Tab {{index+1}}</el-button>-->
          <!--以tag的形式筛选-->
          <el-button type="danger" round @click="dappChange('All')"
                     :class="{active:'All'===tagButton}">All
          </el-button>
          <el-button type="danger" round @click="dappChange(tag)"
                     :class="{active:tag===tagButton}"
                     v-for="(tag, index) in tags"
                     :key="index">{{tag}}
          </el-button>
          <el-button class="more" type="text">
            {{$t("button.seemore")}}<img alt="more" class="icon" src="@/assets/images/icon/more.png"/>
          </el-button>
        </div>
        <el-row class="dapps" type="flex" justify="center" >
          <el-col :span="1" :offset="1">
            <div class="dapps-left-arrow">
              <img v-show="currentPage!==0" id="leftArrow" alt="" src="@/assets/images/icon/dapps_left_nor.png"
                   @click="prePage"/>
              <img v-show="currentPage===0" alt="" src="@/assets/images/icon/dapps_left_dis.png"/>
            </div>
          </el-col>
          <el-col :span="20" :offset="0">
            <el-row>
              <!--span大小决定一行有多少个，给第一行和第二行的dapp缩进1格-->
              <el-col :span="5" :offset="index===0||index===4 ? 1 : 0" v-for="(dapp,index) in dappsData"
                      :key="index"
                      class="dapp">
                <a :href="dapp.url" class="dapps-url">
                  <div class="dapps-logo"><img alt="dapps" :src=dapp.logoSrc>
                    <br/>
                    <b>{{dapp.title}}</b></div>
                </a>
              </el-col>
            </el-row>
          </el-col>
          <el-col :span="1" :offset="0">
            <div class="dapps-right-arrow">
              <img v-show="(currentPage+1)!==pageMaxNum" id="rightArrow" alt="" src="@/assets/images/icon/dapps_right_nor.png"
                   @click="nextPage"/>
              <img v-show="(currentPage+1)===pageMaxNum" src="@/assets/images/icon/dapps_right_dis.png"/>
            </div>
          </el-col>
        </el-row>
      </el-row>
    </el-row>
    <el-row type="flex" justify="center">
      <el-button class="submit-button i-button" @click="dialogVisible = true">{{$t("button.submit")}}</el-button>
    </el-row>
    <!--lock-scroll用于取消dialog显示时给body增加的padding-->
    <el-dialog
    center
    title="请填写您的应用信息"
    :visible.sync="dialogVisible"
    width="50%"
    :before-close="handleClose"
    :lock-scroll=false>
      <!--自定义标题样式时可以用这个-->
    <!--<span slot="title">请填写您的应用信息</span>-->
      <el-form :model="dappForm" ref="dappForm" label-width="100px" class="demo-dynamic"
               label-position="left">
        <el-row class="flex-center">
          <el-col :span="6">
            <el-form-item
              prop="name"
              label="名称"
              :rules="{required: true, message: '名称不能为空', trigger: 'blur' }">
              <el-input v-model="dappForm.name"></el-input>
            </el-form-item>
          </el-col>
          <el-col :span="14" :offset="4">
            <el-upload
              class="avatar-uploader"
              action="https://jsonplaceholder.typicode.com/posts/"
              :show-file-list="false"
              :on-success="handleAvatarSuccess"
              :before-upload="beforeAvatarUpload">
              <img v-if="imageUrl" :src="imageUrl" class="avatar">
              <i v-else class="el-icon-plus avatar-uploader-icon"></i>
            </el-upload>
          </el-col>
        </el-row>
        <el-form-item label="Dapp标签">
          <el-radio-group v-model="dappForm.tag">
            <el-radio v-for="(tag,index) in tags" :key="index" :label="index">{{tag}}</el-radio>
          </el-radio-group>
        </el-form-item>
        <el-form-item
          v-for="(domain, index) in dappForm.domains"
          :label="'公共链接' + index"
          :key="domain.key"
          :prop="'domains.' + index + '.value'"
          :rules="{required: true, message: '域名不能为空', trigger: 'blur' }">
          <el-input v-model="domain.value"></el-input>
          <el-button @click.prevent="removeDomain(domain)">删除</el-button>
        </el-form-item>
        <el-form-item
          label="一句话描述">
          <el-input
            type="textarea"
            maxlength="10"
            show-word-limit
            placeholder="请输入内容"
            v-model="dappForm.describe">
          </el-input>
        </el-form-item>
        <el-form-item>
          <el-button type="primary" @click="submitForm('dappForm')">提交</el-button>
          <el-button @click="addDomain">新增链接</el-button>
          <el-button @click="resetForm('dappForm')">重置</el-button>
        </el-form-item>
      </el-form>
      <span slot="footer" class="dialog-footer">
       <el-button @click="dialogVisible = false">取 消</el-button>
        <el-button type="primary" @click="dialogVisible = false">确 定</el-button>
      </span>
  </el-dialog>
  </el-card>

</template>

<script>
    export default {
        name: "new-dapps",
      data() {
        return {
          dappForm: {
            domains: [{
              value: ''
            }],
            tag:'',
            describe:'',
            name: ''
          },
          dialogVisible:false,
          imageUrl: '',
          urlSelect:{
            github:"github",
            twitter:"twitter",
            facebook:"facebook",
          },
          tags:[
            "Community","Social","dApp","DeFi"
          ],
          dapps:[
            {
              logoSrc:require('@/assets/images/dapps/icpleague.png'),
              title:"ICPLeague",
              url:"https://www.icpleague.com/",
              tag:"Community"
            },
            {
              logoSrc:require('@/assets/images/dapps/OpenChat.jpg'),
              title:"OpenChat",
              url:"https://7e6iv-biaaa-aaaaf-aaada-cai.ic0.app/",
              tag:"Social"
            },
            {
              logoSrc:require('@/assets/images/dapps/CapsuleSocial.jpg'),
              title:"CapsuleSocial",
              url:"https://capsule.social/",
              tag:"Social"
            },
            {
              logoSrc:require('@/assets/images/dapps/DfiStarter.jpg'),
              title:"DfiStarter",
              url:"https://dfistarter.io/",
              tag:"Social"
            },
            {
              logoSrc:require('@/assets/images/dapps/DFINITY SCAN.webp.jpg'),
              title:"DFINITY SCAN",
              url:"https://www.icp.report/",
              tag:"Community"
            },         {
              logoSrc:require('@/assets/images/dapps/cycle_dao.png'),
              title:"cycle_dao",
              url:"https://cycledao.xyz/",
              tag:"dApp"
            },         {
              logoSrc:require('@/assets/images/dapps/Distrikt.jpg'),
              title:"Distrikt",
              url:"https://twitter.com/DistriktApp",
              tag:"Social"
            },
            {
              logoSrc:require('@/assets/images/dapps/Canistore.png'),
              title:"Canistore",
              url:"https://canistore.io/",
              tag:"Social"
            },
            {
              logoSrc:require('@/assets/images/dapps/EnsoFinance.png'),
              title:"EnsoFinance",
              url:"https://www.enso.finance/",
              tag:"DeFi"
            },
            {
              logoSrc:require('@/assets/images/dapps/aedile.png'),
              title:"aedile",
              url:"https://twitter.com/aedile_ic",
              tag:"dApp"
            },
          ],
          //dapp的显示
          dappsData:{},
          //当前dapp按钮选中的
          tagButton:"All",
          tagDapp:{},
          leftDisable:false,
          rightDisable:false,
          //一页包含的应用数量
          pageSize:8,
          // 从0开始
          currentPage:0,
          // 从1开始
          pageMaxNum:0,
        }
      },
      watch:{
        currentPage(val,oldVal){
          if (this.tagButton !== "All")
          {
            this.dataShow(this.tagDapp);
          }
          else {
            this.dataShow(this.dapps);
          }
        }
      },
      methods: {
        handleAvatarSuccess(res, file) {
          this.imageUrl = URL.createObjectURL(file.raw);
        },
        beforeAvatarUpload(file) {
          const isJPG = file.type === 'image/jpeg';
          const isLt2M = file.size / 1024 / 1024 < 2;

          if (!isJPG) {
            this.$message.error('上传头像图片只能是 JPG 格式!');
          }
          if (!isLt2M) {
            this.$message.error('上传头像图片大小不能超过 2MB!');
          }
          return isJPG && isLt2M;
        },
        submitForm(formName) {
          this.$refs[formName].validate((valid) => {
            if (valid) {
              alert('submit!');
            } else {
              console.log('error submit!!');
              return false;
            }
          });
        },
        resetForm(formName) {
          this.$refs[formName].resetFields();
        },
        removeDomain(item) {
          var index = this.dappForm.domains.indexOf(item)
          if (index !== -1) {
            this.dappForm.domains.splice(index, 1)
          }
        },
        addDomain() {
          this.dappForm.domains.push({
            value: '',
            key: Date.now()
          });
        },
        handleClose(done) {
          this.$confirm('确认关闭？')
            .then(_ => {
              done();
            })
            .catch(_ => {});
        },
        //分页
        dataShow(data){
          let start = this.currentPage*this.pageSize;
          let end = Math.min((this.currentPage+1)*this.pageSize, data.length);
          this.dappsData=data.slice(start, end);
          // return this.dapps.slice(start, end)
        },
        //计算最大页码
        pageMax(data){
          this.pageMaxNum=Math.ceil(data.length / this.pageSize) || 1;
          // if(this.pageMaxNum===1) {}
          return this.pageMaxNum ;
        },
        dappChange(tag){
          //保证切换按钮时是第一页
          this.currentPage=0;
          //如果不是All，就筛选tag
          if (tag !== "All") {
            let tagDapp = this.dapps.filter(function (dapp) {
              //多标签筛选，没有测试过是否ok
              // let tags=dapp.tag.split(",");
              // console.log(tags);
              // for(let itag in tags){
              //     return dapp.tag === itag;
              // }
              return dapp.tag === tag;
            });
            //此标签总共包含的dapp
            this.tagDapp=tagDapp;
            this.pageMax(tagDapp);
            this.dataShow(tagDapp);
          }
          //如果是，就展示全部
          else {

            this.pageMax(this.dapps);
            this.dataShow(this.dapps);
          }
          //标记当前tag的按钮
          this.tagButton=tag;
        },
        nextPage(){
          if (this.currentPage >= this.pageMaxNum - 1)
          {
            // 不循环，下面注解的地方是循环，要循环注解掉return，再恢复注解
            return
            // this.currentPage= 0;
          }
          else this.currentPage++;
        },
        prePage(){
          if (this.currentPage <= 0)
          {
            // 不循环，下面注解的地方是循环，要循环注解掉return，再恢复注解
            return
            // this.currentPage=this.pageMaxNum-1;
          }
          else this.currentPage--;
        },
        toPage(page){
          this.currentPage = page;
        }
      },
      mounted() {
          // 初始化最大页码和分页数据
        this.pageMax(this.dapps);
        this.dataShow(this.dapps);
      }
    }
</script>

<style lang="scss" scoped>
  .icon{
    height: 17px!important;
    width: 8px!important;
    vertical-align: middle;
    margin-left: 5px;
    margin-bottom: 1px;
  }
  /*穿透修改ele组件*/
  .box-card >>> .el-card__body{
    padding: 0px!important;
    /*background-color: rgba(234, 238, 246, 0.4);*/
  }
  .body-logo {
    width: 32px;
    height: 32px;
    margin-right: 10px;
    margin-bottom: 6px;
    vertical-align:middle;
  }
  /*dapps的头部*/
  .subtitle {
    margin: 20px auto 20px auto;
    .el-button--danger{
      width: 101px;
      height: 32px;
      padding: 0;
      background-color:transparent;
      border-radius: 16px;
      border-color:#425CE1;
      color: #425CE1;
      font-weight: bold;
      font-size:14px;
    }
    b{
      margin-right: 20px;
      font-size: 24px;
      font-weight: bold;
      color: #5B5B5B;
    }
  }
  .active{
    background: #425CE1!important;
    color: white!important;
  }
  .more{
    float: right;
  }
  .dapps{
    padding: 20px 0;
    align-items: center;
    margin: 0 auto;
    img {
      width: 150px;
      height: 150px;
    }
    /*dapps图标控制*/
    .el-row .el-col{
      -webkit-box-sizing: border-box;
      box-sizing: border-box;
      /*width: 16%;*/
    }
  }
  .dapp{
    text-align: center;
  }
  .dapps-logo{
    text-align: center;
    width: 200px;
    height: 175px;
    /*background: #1F2937;*/
    border-radius: 25px;
    display: table-cell;
    vertical-align: middle;
    transition: border-color .3s,background-color .3s,color .3s;
    img{
      width: 100px;
      height: 100px;
      border-radius: 25px;
    }
  }
  .dapps-logo:hover{
    background: #EAEEF6;
    opacity: 0.8;
    box-shadow: 0px 3px 10px 0px rgba(153, 153, 153, 0.1);
  }
  .dapps-logo b{
    font-size: 17px;
    color: #333333;
    line-height: 25px;
  }
  /*左右箭头样式*/
  .dapps-left-arrow{
    img{
      width: 21px;
      height: 36px;
    }
  }
  #leftArrow:hover{
    content: url(~@/assets/images/icon/dapps_left_hover.png);
    cursor: pointer;
  }
  .leftDisable{
    content: url(~@/assets/images/icon/dapps_left_dis.png);
  }
  .dapps-right-arrow{
    transition: opacity 5s,background-color .3s,color .3s;
    img{
      width: 21px;
      height: 36px;
    }
  }
  #rightArrow:hover{
    content: url(~@/assets/images/icon/dapps_right_hover.png);
    cursor: pointer;
  }
  .rightDisable{
    content: url(~@/assets/images/icon/dapps_right_dis.png);
  }
  .submit-button{
    width: 223px;
    height: 40px;
    margin: 40px 0;
    line-height: 1px;
    border-radius: 20px!important;
    font-size: 18px;
    font-weight: 500;
    color: #FFFFFF;
  }
  /*上传头像*/
  .avatar-uploader >>> .el-upload {
    border: 1px dashed #d9d9d9;
    border-radius: 6px;
    cursor: pointer;
    position: relative;
    overflow: hidden;
  }
  .avatar-uploader >>> .el-upload:hover {
    border-color: #409EFF;
  }
  .avatar-uploader-icon {
    font-size: 28px;
    color: #8c939d;
    width: 178px;
    height: 178px;
    line-height: 178px;
    text-align: center;
  }
  .avatar {
    width: 178px;
    height: 178px;
    display: block;
  }
</style>
