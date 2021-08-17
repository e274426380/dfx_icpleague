<template>
  <el-container class="bg">
      <new-nav/>
      <div class="main-body">
        <!--公告-->
        <el-row class="notice">
          <el-col class="note" :offset="5" :span="14" :xs=xs>
            <div class="header-text" style="text-align: center;">
              <span>{{$t("main.noticeTitle")}}</span>
            </div>
            <p>{{$t("main.noticeSubTitle")}}</p>
          </el-col>
        </el-row>
        <el-row class="main">
          <!--轮播图-->
          <el-row class="section banner">
            <el-col :offset="3" :span="18" :xs=xs>
              <span class="section-head">{{$t("title.actCenter")}}</span>
              <br/>
              <br/>
              <!--轮播图-->
              <el-carousel trigger="click"
                           height="436px"
                           class="i-carousel">
                <el-carousel-item class="banner-logo" v-for="item in 1" :key="item">
                  <el-row style="padding: 60px 100px ">
                    <b class="header-text">ICP League</b>
                    <p class="banner-text">Text description text description text description text description text
                      description t
                      ext description text ...
                    </p>
                    <p>
                      Text description text description text description text description text description t
                      ext description text ...</p>
                  </el-row>
                </el-carousel-item>
              </el-carousel>
            </el-col>
          </el-row>
          <!--dapp-->
          <el-row class="section dapps">
            <el-col :offset="3" :span="18" :xs=xs>
              <span class="section-head">生态导航</span>
              <br/>
              <br/>
              <NewDapps/>
            </el-col>
          </el-row>
          <!--卡片-->
          <el-row class="section developer-card">
            <el-row :gutter="0" style="margin: 0">
              <!--左侧卡片-->
              <el-col :offset="3" :span="9" :xs=xs style="padding-right: 20px">
                <el-card class="box-card">
                  <div slot="header" class="card-head">
                <span class="head-icon">
                  <img class="card-icon" src="@/assets/images/icon/coder.png">
                  <span class="card-title" style="margin-left: 10px">{{$t('title.developerSummary')}}</span>
                </span>
                  </div>
                  <div class="card-text" v-for="(text,index) in coderText" :key="index">
                    <a :href=text.url>
                      {{text.text}}
                      <!--最后一根线不显示-->
                      <el-divider v-if="index<(coderText.length-1)"/>
                      <div v-else-if="index===(coderText.length-1)" style="padding-bottom: 20px"></div>
                    </a>
                  </div>
                  <a href="https://shuzhichengspace.gitbook.io/dfinity/">
                    <el-button class="bottom-button" type="primary">{{$t('button.startCode')}}
                    </el-button>
                  </a>
                </el-card>
              </el-col>
              <!--右侧卡片-->
              <el-col :offset="0" :span="9" :xs=xs style="padding-left: 20px">
                <el-card class="box-card">
                  <div slot="header" class="img-box">
                    <img
                      alt="head"
                      src="https://shadow.elemecdn.com/app/element/hamburger.9cf7b091-55e9-11e9-a976-7f4d0b07eef6.png"
                      class="card-image"/>
                    <a href="https://www.icpleague.com/"><p class="hover" style="text-align: left">论坛</p></a>
                  </div>
                  <div class="card-text" v-for="(data,index) in forumData" :key="index">
                    <a :href="'https://www.icpleague.com/thread/'+data.threadId">
                      {{data.title}}
                      <!--最后一根线不显示-->
                      <el-divider v-if="index<(rightText.length-1)"/>
                      <div v-else style="padding-bottom: 20px"></div>
                    </a>
                  </div>
                  <a href="https://www.icpleague.com/">
                    <el-button class="bottom-button" type="primary">{{$t('button.joinDiscuss')}}</el-button>
                  </a>
                </el-card>
              </el-col>
            </el-row>
          </el-row>
          <!--招募，订阅-->
          <el-row class="section help">
            <el-row>
              <el-col :offset="3" :span="18" :xs=xs>
                <el-row class="help-head">
                  <el-col :offset="0" :span="24" :xs=xs>
                    <span>{{$t('title.help')}}</span>
                    <hr/>
                  </el-col>
                  <el-col :offset="6" :span="12" :xs=xs>
                    <p>{{$t('title.helpSubtitle')}}</p>
                  </el-col>
                </el-row>
                <el-row class="help-body">
                  <el-row>
                    <!--<span class="section-head">{{$t("title.howtohelp")}}</span>-->
                    <!--<br/>-->
                    <!--<br/>-->
                  </el-row>
                  <el-row >
                    <el-col class="help-line" :span="12" :xs=xs>
                      <p class="help-body-head">{{$t('title.developers')}}</p>
                      <p class="help-body-text">{{$t('main.devText')}}</p>
                      <el-row type="flex" justify="start">
                        <el-button class="i-button help-button">{{$t('button.startTeam')}}</el-button>
                      </el-row>
                    </el-col>
                    <el-col class="help-co" :offset="1" :span="11" :xs=xs>
                      <p class="help-body-head">{{$t('title.project')}}</p>
                      <p class="help-body-text">{{$t('main.teamText')}}</p>
                      <el-row type="flex" justify="start">
                        <el-button class="i-button help-button">{{$t('button.startCooper')}}</el-button>
                      </el-row>
                    </el-col>
                  </el-row>
                  <br/>
                  <br/>
                  <el-row type="flex" class="email">
                    <div class="email-title">
                      <p>{{$t('main.email')}}</p>
                      <!--<p>分享您的电子邮件以接收指南 和行业新闻。</p>-->
                    </div>
                      <!--<div class="email-container">-->
                        <!--<el-input class="email-input" v-model="email" placeholder="输入你的电子邮箱">-->
                          <!--输入框内置的大按钮-->
                          <!--<el-button slot="append" id="email-button">订阅</el-button>-->
                        <!--</el-input>-->
                        <!--&lt;!&ndash;用定位移动进输入框的按钮&ndash;&gt;-->
                        <!--&lt;!&ndash;<el-button class="email-button">订阅</el-button>&ndash;&gt;-->
                      <!--</div>-->
                      <el-input
                        class="email-input" v-model="email" :placeholder="$t('button.inputEmail')">
                      </el-input>
                    <el-button class="sign i-button help-button">{{$t('button.subscribe')}}</el-button>
                  </el-row>
                </el-row>
              </el-col>
            </el-row>
            <!--合作伙伴-->
            <el-row class="section co-partner">
              <el-col class="partner" :offset="3" :span="18" :xs=xs>
                <span class="section-head">{{$t("title.partners")}}</span>
                <br/>
                <br/>
                <img v-for="partner in partners" :src=partner.imgSrc>
              </el-col>
            </el-row>
          </el-row>
        </el-row>
        <NewFooter/>
      </div>
    </el-container>
</template>

<script>
  import request from '@/utils/request.js';
  import NewFooter from '@/components/new-footer.vue';
  import NewDapps from '@/components/new-dapps.vue';
  import NewNav from '@/components/new-nav.vue';
  export default {
    name: 'Main',
    components: {NewNav, NewDapps, NewFooter},
    data() {
      return {
        dialogVisible:false,
        //语言环境
        lang: 'cn',
        xs:this.$store.state.xs,
        coderText:[
          {
            text:"一、快速入门 DFINITY Canister软件...",
            url:"https://shuzhichengspace.gitbook.io/dfinity/yi-kuai-su-ru-men",
          },
          {
            text:"二、基本概念 在Internet Computer...",
            url:"https://shuzhichengspace.gitbook.io/dfinity/er-ji-ben-gai-nian",
          },
          {
            text:"三、手把手 Canister SDK-开发工具...",
            url:"https://shuzhichengspace.gitbook.io/dfinity/san-shou-ba-shou",
          },
          {
            text:"四、教程 接下来，我们将探索编写...",
            url:"https://shuzhichengspace.gitbook.io/dfinity/si-.-jiao-cheng",
          },
          // {
          //   text:"五、语言 语言和 API 参考信息是...",
          //   url:"https://shuzhichengspace.gitbook.io/dfinity/liu-yu-yan",
          // },
        ],
        rightText:[
          "我是文本描述文本描述文本描述文本描述1",
          "我是文本描述文本描述文本描述文本描述2",
        ],
        //论坛数据
        //现在使用threadId来定位超链接，而不是url
        forumData: [
          {
            title: "DFINITY链上钱包创建流程",
            content: "一、准备好环境及相关硬件\n" +
              "\n" +
              "1.1 因为Dfinity钱包是与U2F硬件设备绑定的，所以iPhone,带指纹识别...",
            url:"https://www.icpleague.com/thread/59",
            threadId:"59",
            username:"Turbo",
            // 头像地址
            avatarUrl:"",
          },
          {
            title: "如何使用DFINITY的治理系统赚取ICP？",
            content: "注意：目前NNS刚投入使用100小时，可能存在BUG，请保证手续费充足，谨慎操作！\n" +
              "\n" +
              "上一篇文章介绍了如何...",
            url:"https://www.icpleague.com/thread/47",
            threadId:"47",
            username:"Turbo",
            // 头像地址
            avatarUrl:"",
          }
        ],
        email:"",
        partners:[
          {
            name:"星球日报",
            imgSrc:require("@/assets/images/partners/星球日报.png"),
            url:"",
          },
          {
            name:"链闻",
            imgSrc:require("@/assets/images/partners/链闻.png"),
            url:"",
          },
          {
            name:"链闻",
            imgSrc:require("@/assets/images/partners/链闻.png"),
            url:"",
          },
        ]
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
      //切换语言
      switchLang()  {
        this.$i18n.locale = this.lang
      },
      // // 滚动一定像素以后，改变导航条背景颜色
      // handleScroll () { //改变元素#searchBar的top值
      //   var scrollTop = window.pageYOffset || document.documentElement.scrollTop || document.body.scrollTop;
      //   if(scrollTop>=129){
      //     document.querySelector('#nav').style.backgroundColor = "#ffffff";
      //     document.querySelector('#nav').style.marginTop = "0";
      //     document.querySelector('.nav-menu').style.borderBottom = "1px soild black";
      //   }else {
      //     var scrollMargin=20-scrollTop/10;
      //     document.querySelector('#nav').style.marginTop = scrollMargin+"px";
      //     document.querySelector('#nav').style.backgroundColor = "rgba(000, 000, 000, 0)";
      //   }
      // },
      // 获取论坛相关贴子资料
      getForumEssence(){
        request({
          url:"/threads",
          method:"get",
          params:{
            include:"user",
            "filter[isEssence]":"yes",
            sort:"-createdAt"
          }
        }).then((resp)=>{
          //只取精华贴的最近2个
          const forumData=resp.data.slice(0,2);
          //获取精华贴中包含的用户名，用来和贴子的作者匹配
          let user = resp.included.filter(function (user) {
            return user.type === "users";
          });
          //正则表达式，过滤文章内容，移除[]，()及其内容，还有感叹号！星号*，用于处理一些不协调的网页元素
          let regex=/\[.*?\]|\(.*?\)|[!*]|\#.*?\#/g;
          //提前定义length，优化下for循环效率
          for (let i = 0,length = forumData.length; i <length; i++) {
            // 标题只留0到30个字符，并在结尾加上...
            this.forumData[i].title=forumData[i].attributes.title.slice(0,25)+"...";
            const poster = user.find(user=>user.id=== forumData[i].relationships.user.data.id);
            //只留首字母大写
            this.forumData[i].username=poster.attributes.username.slice(0,1).toUpperCase();
            this.forumData[i].threadId=forumData[i].id;
            // 正则表达式筛选贴子内容
            forumData[i].attributes.postContent=forumData[i].attributes.postContent.replace(regex,'');
            // 内容只留0到55个字符，并在结尾加上...
            this.forumData[i].content=forumData[i].attributes.postContent.slice(0,55)+"...";
          }

        }).catch((error)=>{

        })
      },
      getFirstLetter(datas) {
        for (const data of datas) {
          data.username = data.username.slice(0, 1).toUpperCase();
        }
        return datas;
      },
    },
    mounted() {
      //给window添加一个滚动滚动监听事件
      // window.addEventListener('scroll', this.handleScroll);
      this.switchLang();
      this.getForumEssence();
    },
    // destroyed () {
    //   //离开该页面需要移除这个监听的事件
    //   window.removeEventListener('scroll', this.handleScroll);
    // },
  }
</script>

<style scoped>
  a{
    text-decoration:none;
    color: inherit;
  }
  /*定义全局字体样式*/
  #app {
    /*font-size: 16px;*/
  }
  .section{
    /*padding:40px 0;*/
    margin-top:80px;
  }
  .co-partner{
    padding-bottom: 70px;
  }
  /*覆盖main的padding，保证背景图不会有空白*/
  .el-main{
    padding: 0;
  }
  .notice{
    background-image:url("~@/assets/images/header-background.png");
    /*background-color:#eaeef6;*/
    background-size:100% 100%;
    font-size: 24px;
    font-weight: 400;
    color: #FFFFFF;
    font-family: JetBrains Mono;
  }
  .note{
    padding:150px 0 50px 0;
    text-align: center;
  }
  .header-text{
    font-size: 60px;
    /*font-family: FZZDHJW;*/
    text-shadow: 0px 3px 10px rgba(0, 0, 0, 0.2);
  }
  .bg{
    background-image:url("~@/assets/images/BG@2x.png");
    background-size:100% 100%;
  }
  .main-body{
    width: 100%;
  }
  .developer-card{
    z-index: 1;
    transform:translateY(100px);
    margin: 0;
  }
  .box-card{
    border-radius: 36px;
  }
  .box-card >>> .el-card__body{
    padding:0 20px;
  }
  .hover{
    margin: 0;
    padding: 20px 0 0 0;
  }
  /*消除卡片阴影*/
  .section >>> .el-card{
    box-shadow: 0 0 0;
  }
  .card-text{
    padding: 20px 20px 0 20px;
    transition: border-color .3s,background-color .3s,color .3s;
    border-radius: 16px;
    font-weight: 600;
    font-size: 20px;
    color: rgba(51, 51, 51, 1);
  }
  .card-text:hover{
    background: #EAEEF6;
    opacity: 0.8;
    box-shadow: 0px 3px 10px 0px rgba(153, 153, 153, 0.1);
  }
  .card-text >>> .el-divider{
    margin-top: 24px;
    margin-bottom: 0;
  }
  .card-head{
    padding: 20px 0 7px 20px;
  }
  .card-icon{
    vertical-align: middle;
    margin-bottom: 8px;
    height: 48px
  }
  .card-title{
    font-size: 22px;
    font-weight: 600;
    color: #333333;
  }
  .bottom-button{
    border-radius: 8px;
    float: right;
    margin-top: 36px;
    margin-right: 20px;
    margin-bottom: 20px;
    padding: 5px 10px;
    height: 40px;
    /*width: 89px;*/
    border-color:rgba(66, 92, 225, 0.85);
    font-size: 18px;
    font-weight: 400;
    color: #FEFEFF;
    background-color: rgba(66, 92, 225, 0.85);
    transition: .2s;
  }
  .bottom-button:hover{
    /*border:2px solid rgba(66, 92, 225, 0.85);*/
    background-color: rgba(66, 92, 225, 1)!important;
    border-color:rgba(66, 92, 225, 1)!important;
    font-weight: 600;
    color: #FFFFFF;
  }
  .img-box{
    text-align:center;
  }
  .card-image{
    width: 90%;
    height: 180px;
    background: #F3F3F3;
    border-radius: 18px;
  }
  /*每章节标题样式*/
  .section-head{
    font-size: 24px;
    font-weight: bold;
    color: #333333;
    /*阴影下划线*/
    /*box-shadow: 0 -10px #EA3D5A inset;*/
    border-bottom:3px solid #EA3D5A;
    /*文字下划线*/
    /*text-decoration:underline #EA3D5A;*/
  }
  .i-carousel{
    /*max-height: 430px;*/
  }
  .el-carousel__item{
    color: white;
    /*border-radius: 60px;*/
  }
  .banner-logo {
    /*background-color:#EA3D5A;*/
    background-image: url(~@/assets/images/logo-background1.png);
    background-size: 100% 100%;
  }
  .banner-logo p{
    font-size: 20px;
    font-weight: 400;
  }
  .banner-text{
    margin-top: 80px;
  }
  .help{
    /*裁剪效果，目前不知道如何保留*/
    /*clip-path:ellipse(100% 2% at 50% 0%);*/
    margin-top: 0px;
    background-image: url(~@/assets/images/lower-background.png);
    background-size: 100% 100%;
    /*background: linear-gradient(224deg, #5ED1E1 0%, #BFC2FE 50%, #E8BDDB 100%);*/
    padding: 160px 0 60px 0;
  }
  .help-head{
    text-align: center;
  }
  .help-head span:first-child{
    font-size: 65px;
    font-weight: bold;
    color: #333333;
  }
  .help-head p{
    font-size: 18px;
    font-weight: 400;
    color: #727272;
    margin-bottom: 60px;
  }
  .help-head hr{
    margin: 30px auto;
    width: 67px;
    height: 6px;
    background: #D6283E;
    border-radius: 3px;
    border-color:#D6283E ;
  }
  .help-line{
    border-right:4px solid rgba(255, 255, 255,0.4);
    padding-right: 50px;
    padding-bottom: 20px;
  }
  .help-body-head{
    font-size: 20px;
    font-weight: 700;
    color: #333333;
  }
  .help-body-text{
    font-size: 18px;
    font-weight: 400;
    color: #727272;
  }
  .help-button{
    text-align: center;
    width: 80%;
    border-radius:6px;
    font-size: 24px;
  }
  .email-title{}
  .email-title p:first-child{
    font-size: 28px;
    font-weight: 900;
    color: #333333;
  }
  .email-title p:nth-child(2){
    font-size: 24px;
    font-weight: normal;
    color: #717171;
  }
  .email{
    align-items: center;
    justify-content:space-between;
  }
  .email-input{
    width: 60%;
  }
  #email-button{
    text-align: center;
    /*保持高度一致*/
    height: 70px;
    font-size:32px;
    color: #333333;
    font-weight: 500;
    transition:0.3s;
  }
  #email-button:hover{
    /*color: white;*/
  }
  .email-input >>> .el-input__inner{
    background: #F5F5F5;
    height: 55px;
    font-size: 20px;
    font-weight: 500;
    color: #A1A1A1;
    border-radius: 12px;
    /*border: 0;*/
    /*内置按钮时启用只有左边有弧角*/
    /*border-radius: 35px 0 0 35px;*/
  }
  /*内置按钮时启用外壳重写*/
  /*.email-container{*/
       /*background: #F5F5F5;*/
       /*border: 1px solid #7D7D7D;*/
       /*border-radius: 12px;*/
       /*width:70%;*/
     /*}*/
  /*内置按钮时启用内置按钮样式重写*/
  /*.email-input >>> .el-input-group__append{*/
    /*border-radius:35px;*/
    /*background: linear-gradient(264deg, #5ED1E1 0%, #BFC2FE 50%, #E8BDDB 100%);*/
    /*background-size: 200%;*/
    /*width: 30%;*/
    /*transform:translateX(3px);*/
    /*z-index: 10;*/
    /*text-align: center;*/
    /*border: 1px solid #CCC9B8;*/
    /*!*box-shadow: 0px 0px 2px 3px #CCC9B8;*!*/
    /*transition: background-position .5s,box-shadow 0.3s,color 0.3s;*/
  /*}*/
  /*.email-input >>> .el-input-group__append:hover{*/
    /*background-position: 100% 0;*/
    /*box-shadow: 0 0;*/
    /*color: white!important;*/
    /*cursor: pointer;*/
  /*}*/
  .sign{
    width: 116px!important;
    height: 40px;
    line-height:1px;
    text-align: center;
    background: rgba(66, 92, 225, 0.85);
    border-radius: 20px;
    font-size: 18px;
    font-weight: 600;
  }
  .partner img{
    max-height: 60px;
    margin-right: 20px;
  }
</style>
