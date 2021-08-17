<template>
  <div>
    <new-nav/>
    <div class="main">
      <!--头部-->
      <el-row class="head-dapp">
        <el-col class="note" :offset="3" :span="18" :xs=this.$store.state.xs
          style="display:flex;align-content: flex-start">
          <img src="@/assets/images/dapp/bulb.png">
          <div class="head-float">
            <div class="header-text">
              <span>Dfinity Library</span>
              <span class="header-subtitle">
          Where you can find out more Diffinity dapps
            or upload your dapps.
            </span>
            </div>
            <el-button class="i-button">Explore DAPP</el-button>
            <el-button class="i-button">Explore DAPP</el-button>
          </div>
        </el-col>
      </el-row>
      <!--轮播图，dapp部分-->
      <el-row class="body">
        <el-col :offset="3" :span="18" :xs=this.$store.state.xs>
          <!--轮播图-->
          <el-row class="banner">
            <el-carousel trigger="click"
                         height="436px"
                         class="i-carousel">
              <el-carousel-item class="banner-logo" v-for="item in 4" :key="item">
                <el-row style="padding: 60px 100px ">
                </el-row>
              </el-carousel-item>
            </el-carousel>
          </el-row>
          <el-row class="dapp">
            <el-row style="margin-bottom: 45px">
              <div class="subtitle" style="display:flex;justify-content: space-between">
                <!--以tag的形式筛选-->
                <div>
                <span @click="dappChange('All')"
                      :class="{active:'All'===tagButton}">All
                </span>
                  <span @click="dappChange(tag)"
                        :class="{active:tag===tagButton}"
                        v-for="(tag, index) in tags"
                        :key="index">{{tag}}
                </span>
                </div>
                <div class="search">
                  <el-input
                    placeholder="search"
                    prefix-icon="el-icon-search"
                    v-model="search">
                  </el-input>
                </div>
              </div>
            </el-row>
            <el-row :gutter="40">
              <el-col :md="12" :lg="8" v-for="(dapp,index) in dapps" :key="index" class="dapp-card">
                <el-card shadow="never">
                  <div class="flex-center">
                    <el-avatar :size="72" :src="dapp.avatar"></el-avatar>
                    <div class="dapp-top">
                      <div class="flex-center">
                        <span class="dapp-title">Dapp name</span>
                        <span class="badge">Hot</span>
                      </div>
                      <br/>
                      <div class="flex-center member">
                        <el-avatar :size="20" v-for="(member,index) in dapp.members" :key="index">
                          {{member}}
                        </el-avatar>
                        <span class="grant">+ 6 Grant</span>
                      </div>
                    </div>
                  </div>
                  <el-divider/>
                  <div class="dapp-botoom">
                    <span>{{dapp.describe}}</span>
                    <br/>
                    <el-tag v-for="tag in dapp.tags"
                      :key="tag">
                      {{ tag }}
                    </el-tag>
                    <br/>
                    <el-avatar :size="27" v-for="item in 4" :key="item.index">
                      <i class="bi bi-twitter"></i>
                    </el-avatar>
                    <el-row type="flex" justify="space-between" style="margin-top: 23px">
                      <!--整体按钮使用水平反转，写动画样式时需注意-->
                      <el-button class="share flip-horizontal i-button"><i class="bi bi-reply-fill"></i></el-button>
                      <el-button class="view i-button"><i class="bi bi-arrow-right-short" style="font-size:1.1em;"></i>
                        <span> View</span></el-button>
                    </el-row>
                  </div>
                </el-card>
              </el-col>
            </el-row>
          </el-row>
        </el-col>
      </el-row>
    </div>
    <new-footer>
      <!--有插槽可用-->
    </new-footer>
  </div>
</template>

<script>
  import NewNav from "@/components/new-nav.vue";
  import NewFooter from "@/components/new-footer.vue";
    export default {
        name: "index",
        components: {NewFooter, NewNav},
        data() {
        return {
          dialogVisible:false,
          //语言环境
          lang: 'cn',
          search:'',
          readonly: true,
          tags:["Community","Social","DApp","DeFi"],
          //当前dapp按钮选中的
          tagButton:"All",
          //一页包含的应用数量
          pageSize:8,
          // 从0开始
          currentPage:0,
          // 从1开始
          pageMaxNum:0,
          dapps:[
            {
              avatar:require('@/assets/images/blank.svg'),
              title:"ICPLeague",
              members:["T","C","D"],
              describe:"Your dapp product description according in this area",
              url:"https://www.icpleague.com/",
              tags:["Community","Defi","DApp"]
            },
            {
              avatar:require('@/assets/images/blank.svg'),
              title:"ICPLeague",
              members:["T","C","D"],
              describe:"Your dapp product description according in this area",
              url:"https://www.icpleague.com/",
              tags:["Community","Defi","DApp"]
            },
            {
              avatar:require('@/assets/images/blank.svg'),
              title:"ICPLeague",
              members:["T","C","D"],
              describe:"Your dapp product description according in this area",
              url:"https://www.icpleague.com/",
              tags:["Community","Defi","DApp"]
            },
            {
              avatar:require('@/assets/images/blank.svg'),
              title:"ICPLeague",
              members:["T","C","D"],
              describe:"Your dapp product description according in this area",
              url:"https://www.icpleague.com/",
              tags:["Community","Defi","DApp"]
            },
          ],
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
      methods:{
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
          } else {
            //如果是，就展示全部
            this.pageMax(this.dapps);
            this.dataShow(this.dapps);
          }
          //标记当前tag的按钮
          this.tagButton=tag;
        },
        nextPage(){
          if (this.currentPage >= this.pageMaxNum - 1)
          {
            // 不循环分页，下面注解的地方是循环，要循环注解掉return，再恢复注解
            return
            // this.currentPage= 0;
          }
          else this.currentPage++;
        },
        prePage(){
          if (this.currentPage <= 0)
          {
            // 不循环分页，下面注解的地方是循环，要循环注解掉return，再恢复注解
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

<style scoped>
  .main{
    font-family: JetBrains Mono;
  }
  .body{
    background-image:url("~@/assets/images/dapp/dapp-body-bg.png");
    background-size:100% 100%;
  }
  .head-dapp{
    background-image:url("~@/assets/images/dapp/dapp-head-bg.png");
    /*background-color:#eaeef6;*/
    background-size:100% 100%;
    font-size: 24px;
    font-weight: 400;
    color: #1F1F1F;
    padding:100px 0 50px 0;
  }
  .head-float{}
  .header-text span{
    float: right;
  }
  .head-float button{
    float: right;
    width: unset;
    font-family: 微软雅黑;
    font-weight: bold;
    margin-left: 36px;
  }
  .header-text{
    padding-top: 50px;
    font-size: 58px;
    /*font-family: FZZDHJW;*/
  }
  .header-subtitle{
    margin-top: 50px;
    margin-bottom: 80px;
    font-size: 36px;
    font-weight: 400;
    color: rgba(31, 31, 31, 0.6);
    text-align:right;
  }
  .el-carousel__item:nth-child(2n) {
    background-color: rgba(242, 208, 235, 0.8);
  }
  .el-carousel__item:nth-child(2n+1) {
    background-color: #d3dce6;
  }
  .i-carousel{
    border-radius: 8px;
  }
  .banner{
    margin-top: 50px;
    margin-bottom: 100px;
  }
  .dapp{
    width: 100%;
  }
  .subtitle{
    float: left;
    width: 100%;
  }
  .subtitle span{
    float: left!important;
    margin-right: 36px;
    font-size: 26px;
    font-family: JetBrains Mono;
    font-weight: 400;
    color: #727272;
    transition:transform .3s,color .3s;
  }
  .subtitle span:hover{
    cursor: pointer;
    transform:translateY(-10px);
    color: #5C72E5;
    border-bottom:2px solid #5C72E5;;
    padding-bottom: 4px;
  }
  .active{
    color: #5C72E5!important;
    border-bottom:2px solid #5C72E5!important;
    padding-bottom: 4px!important;
  }
  .active:hover{
    transform:translateY(0px)!important;
  }
  .search{
    float: right;
  }
  .search >>> .el-input__inner{
    font-family: JetBrains Mono;
    font-weight: 400;
  }
  .dapp-card{
    margin-bottom: 36px;
  }
  .dapp-card >>> .el-avatar>img {
    /*elavatar没有加width导致不是1：1的图片会变形*/
    width: 100%;
  }
  .dapp-top{
    margin-left:24px;
  }
  .badge{
    background: #F9695E;
    border-radius: 4px;
    padding: 1px 5px;
    font-size: 14px;
    font-family: JetBrains Mono;
    font-weight: 400;
    color: #FFFFFF;
    margin-left: 23px;
  }
  /*ele的badge组件改写*/
  /*.badge >>> sup{*/
    /*transform:translateY(0%) translateX(140%)!important;*/
    /*border-radius: 4px;*/
  /*}*/
  .dapp-title{
    font-size: 30px;
    font-family: JetBrains Mono;
    font-weight: 600;
    color: #333333;
  }
  .dapp-card >>> .el-divider{
    margin-top: 17px;
    margin-bottom: 11px;
  }
  .dapp-card >>> .el-card{
    background: #F0F2FE;
    border-radius: 6px;
  }
  .member{}
  .member span{
    margin-right: 11px;
  }
  .member .grant{
    font-size: 18px;
    font-family: JetBrains Mono;
    font-weight: 600;
    color: #727272;
  }
  .dapp-card >>> .el-tag{
    background: #F5D8C4;
    border-radius: 6px;
    font-size: 14px;
    font-family: JetBrains Mono;
    font-weight: 600;
    color: #F59D62;
    border: 0;
    margin-right: 12px;
    margin-top: 18px;
  }
  .dapp-botoom >>> .el-avatar {
    background: #4fabff;
    margin-right: 12px;
    margin-top: 11px;
  }
  .share{
    width: 67px;
    height: 33px;
    padding: 0;
    border-radius: 6px;
  }
  .view{
    width: 259px;
    height: 33px;
    padding: 0;
    border-radius: 6px;
  }
</style>
