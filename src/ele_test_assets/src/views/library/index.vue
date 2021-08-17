<template xmlns:v-slot="http://www.w3.org/1999/XSL/Transform">
  <div>
    <new-nav/>
    <div class="main">
      <!--头部-->
      <el-row class="head-library">
        <el-col class="note" :offset="3" :span="11" :xs=this.$store.state.xs>
          <div class="header-text">
            <span>Divinity Library</span>
          </div>
          <span class="subtitle">No experience, no worries! Work hands-on with top
            leaders in Difinity blockchain to level up your development skills.</span>
        </el-col>
        <el-col class="head-img" :offset="0" :span="8" :xs=this.$store.state.xs>
          <img src="@/assets/images/library/study.png">
        </el-col>
      </el-row>
      <el-row class="section feature">
        <el-col  :offset="3" :span="18" :xs=this.$store.state.xs>
          <el-row>
            <!--<el-col :offset="3" :span="16">-->
              <!--<el-form class="copy-input" label-width="400px">-->
                <!--<el-form-item label="Install The Computer SDK">-->
              <!--<el-input v-model=code readonly>-->
                <!--<template v-slot:suffix>-->
                  <!--<i class="input-icon el-icon-document-copy" @click="copyToClipboard(this.code)"></i>-->
                <!--</template>-->
              <!--</el-input>-->
                <!--</el-form-item>-->
              <!--</el-form>-->
            <!--</el-col>-->
            <el-col :offset="1" :span="22" class="flex-center copy-input">
              <span class="input-title">Install The Computer SDK</span>
              <el-input v-model='code' readonly>
                <template v-slot:suffix>
                  <i class="input-icon el-icon-document-copy" @click="copyToClipboard(code)"></i>
                </template>
              </el-input>
            </el-col>
          </el-row>
          <el-row>
            <p class="feature-top-text">There is your banner's name2, you can edit that in the manager sever.There is your banner's name2, you can edit
              that in the manager sever.There is your banner's name2, you can edit that in the manager sever.There is your banner's
              name2, you can edit that in the manager sever.There is your banner's name2, you can edit that in the manager sever.
            </p>
          </el-row>
          <el-row style="margin-top: 20px">
            <el-col v-for="(feature,index) in featuresData" :span="6" class="featureData"
                    :key="index"
                    :class="{
                    featureBottom:index<4,
                    NorightBorder:index===3||index===7}">
                <span class="feature-title">{{feature.feature}}</span>
                <span class="feature-text">{{feature.text}}</span>
            </el-col>
          </el-row>
        </el-col>
      </el-row>
      <el-row class="section wishList">
        <el-col :offset="3" :span="18" :xs=this.$store.state.xs >
          <el-row :gutter="20">
            <el-col :span="6" v-for="(card,index) in cardData" :key="index">
              <el-card class="quick-card" :body-style="{ padding: '30px'}" shadow="never">
                <div slot="header" class="card-head">
                  <img alt="" :src=card.imgSrc class="image">
                </div>
                <div class="card-text">
                  <span>{{card.text}}</span>
                </div>
              </el-card>
            </el-col>
          </el-row>
          <el-row class="flex-center" style="margin-top: 80px">
            <el-col :span="12">
                <div style="height: 460px;background: #EEEEEE;border-radius: 8px; ">
                </div>
            </el-col>
            <el-col :offset="1" :span="11">
              <div class="left-border">
                <p class="blue-title">First Tutorials ></p>
                <span class="text-subtitle1">For very first balabalabala xxxxx xxxx xxxxxxxx xxxx xx x x xxxxxx xxxx xxxxx x xxxxx x x. xxxxxxxx.</span>
              </div>
              <div class="left-border">
                <p class="blue-title">Ask Question (Form) ></p>
                <span class="text-subtitle1">For very first balabalabala xxxxx xxxx xxxxxxxx xxxx xx x x xxxxxx xxxx xxxxx x xxxxx x x. xxxxxxxx.</span>
              </div>
              <div class="left-border">
                <p class="blue-title">Find Team (Form) ></p>
                <span class="text-subtitle1">For very first balabalabala xxxxx xxxx xxxxxxxx xxxx xx x x xxxxxx xxxx xxxxx x xxxxx x x. xxxxxxxx.</span>
              </div>
            </el-col>
          </el-row>
          <el-row style="margin-top: 36px" >
            <el-col :span="24">
              <div class="wishlist flex-center">
                  <div class="flex-center">
                    <img style="margin-left: 70px" alt="wishList" src="@/assets/images/library/wishlist.png">
                    <div class="wishlist-text">
                      <p>Wish List</p>
                      <p>Check out what Difinity whant</p>
                    </div>
                  </div>
                  <img style="margin-right: 36px" alt="rightArrow" src="@/assets/images/library/rightArrow.png"/>
              </div>
            </el-col>
          </el-row>
        </el-col>
      </el-row>
      <el-row class="section activity">
        <el-col :offset="3" :span="18" :xs=this.$store.state.xs >
          <el-row class="flex-center act-head" type="flex" justify="space-between">
            <div>
              <span>Learn by Activity</span>
              <span>Join a community of life-long learners</span>
            </div>
            <div>
              <el-button class="more-button i-button " style="margin-right: 20px">More</el-button>
            </div>
          </el-row>
          <el-row>
            <el-col :span="24" class="act-card" v-for="(act,index) in actData" :key="index">
              <el-col :span="6" class="act-img">
                  <img alt="" :src=act.imgSrc>
              </el-col>
              <el-col :span="18" class="act-text">
                <div class="flex-center act-text-head" style="justify-content: space-between">
                  <span>{{act.title}}</span>
                  <span>{{act.startDate}} - {{act.endDate}}</span>
                </div>
                <div class="act-content">
                  {{act.content}}
                </div>
              </el-col>
            </el-col>
          </el-row>
        </el-col>
      </el-row>
      <el-row class="section community">
        <el-col :offset="3" :span="18" :xs=this.$store.state.xs>
          <div>
              <span class="section-title" style="margin-bottom: 36px">Community</span>
          </div>
          <el-row>
            <el-col class="community-card flex-center" style="justify-content: space-between"
                    :offset="0" :span="11" :xs=this.$store.state.xs>
              <div class="flex-item">
                <p class="section-title community-title">FORM</p>
                <el-button class="more-button i-button">More</el-button>
              </div>
              <div>
                <img alt="form" src="@/assets/images/library/form.png"/>
              </div>
            </el-col>
            <el-col class="community-card flex-center" style="justify-content: space-between;
                          margin-left: 34px"
                    :offset="0" :span="11" :xs=this.$store.state.xs>
              <div class="flex-item">
                <p class="section-title community-title">Difinity Blog</p>
                <el-button class="more-button i-button">More</el-button>
              </div>
              <div>
                <img alt="form" src="@/assets/images/library/blog.png"/>
              </div>
            </el-col>
          </el-row>
        </el-col>
      </el-row>
    </div>
    <new-footer>
      <!--自定义插槽-->
      <!--<el-row>-->
        <!--<el-col :offset="1" :span="22" :xs=this.$store.state.xs>-->
           <!--<span class="footer-title">-->
          <!--There is your banner's name1, you can edit that in the manager sever.-->
          <!--</span>-->
          <!--<span class="footer-subtitle">Subscribe to get the latest hackathon updates</span>-->
          <!--<el-col :offset="0" :span="24" class="flex-center email-input">-->
            <!--<el-input v-model=email placeholder="输入你的电子邮箱">-->
            <!--</el-input>-->
            <!--<el-button class="i-button sign">订阅</el-button>-->
          <!--</el-col>-->
        <!--</el-col>-->
      <!--</el-row>-->
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
          code:"$ sudo -i  \"$(curl -fsSL http://sdk.abc.com)\"",
          readonly: true,
          featuresData:[
            {
              feature:"Feature 1",
              text:'Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text .',
            },
            {
              feature:"Feature 2",
              text:'Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text .',
            },
            {
              feature:"Feature 3",
              text:'Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text .',
            },
            {
              feature:"Feature 4",
              text:'Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text .',
            },
            {
              feature:"Feature 5",
              text:'Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text .',
            },
            {
              feature:"Feature 6",
              text:'Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text .',
            },
            {
              feature:"Feature 7",
              text:'Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text .',
            },
            {
              feature:"Feature 8",
              text:'Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text .',
            },
          ],
          cardData:[
            {
              imgSrc:require('@/assets/images/library/rocket.png'),
              text:"Quick Start >",
              href:""
            },
            {
              imgSrc:require('@/assets/images/library/hands.png'),
              text:"For Personal >",
              href:""
            },
            {
              imgSrc:require('@/assets/images/library/dev.png'),
              text:"For Developer >",
              href:""
            },
            {
              imgSrc:require('@/assets/images/library/whitepaper.png'),
              text:"Whitepaper >",
              href:""
            },
          ],
          actData:[
            {
              imgSrc: 'https://shadow.elemecdn.com/app/element/hamburger.9cf7b091-55e9-11e9-a976-7f4d0b07eef6.png',
              title: "Teaching Activity 1",
              content: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aenean euismod bibendum laoreet. Proin gravida dolor sit " +
                "amet lacus accumsan et viverra justo commodo. Proin sodales pulvinar tempor. Cum sociis natoque penatibus et magnis " +
                "dis parturient montes, nascetur ridiculus mus. Nam fermentum, nulla luctus pharetra vulputate, felis tellus mollis orci,",
              startDate: "May 23.2021",
              endDate: "Jul 25.2021",
            },
            {
              imgSrc: 'https://shadow.elemecdn.com/app/element/hamburger.9cf7b091-55e9-11e9-a976-7f4d0b07eef6.png',
              title: "Teaching Activity 2",
              content: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aenean euismod bibendum laoreet. Proin gravida dolor sit " +
                "amet lacus accumsan et viverra justo commodo. Proin sodales pulvinar tempor. Cum sociis natoque penatibus et magnis " +
                "dis parturient montes, nascetur ridiculus mus. Nam fermentum, nulla luctus pharetra vulputate, felis tellus mollis orci,",
              startDate: "May 23.2021",
              endDate: "Jul 25.2021",
            },
            {
              imgSrc: 'https://shadow.elemecdn.com/app/element/hamburger.9cf7b091-55e9-11e9-a976-7f4d0b07eef6.png',
              title: "Teaching Activity 3",
              content: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aenean euismod bibendum laoreet. Proin gravida dolor sit " +
                "amet lacus accumsan et viverra justo commodo. Proin sodales pulvinar tempor. Cum sociis natoque penatibus et magnis " +
                "dis parturient montes, nascetur ridiculus mus. Nam fermentum, nulla luctus pharetra vulputate, felis tellus mollis orci,",
              startDate: "May 23.2021",
              endDate: "Jul 25.2021",
            },
          ],
          email:""
        }
      },
      methods:{
        // 复制模板内容
        copyTemplate() {
          this.copyToClipboard(this.code); // 需要复制的文本内容
        },
        // 点击复制到剪贴板函数
        copyToClipboard(content) {
          if (window.clipboardData) {
            window.clipboardData.setData('text', content);
            this.$message.success(this.$t('success'));
          } else {
            (function (content) {
              document.oncopy = function (e) {
                e.clipboardData.setData('text', content);
                e.preventDefault();
                document.oncopy = null;
              }
            })(content);
            document.execCommand('Copy');
            this.$message.success(this.$t('success'));
          }
        },
      },
      mounted() {
      }
    }
</script>

<style scoped>
  .main{
    font-family: JetBrains Mono;
  }
  .head-library{
    background-image:url("~@/assets/images/library/head-bg.png");
    /*background-color:#eaeef6;*/
    background-size:100% 100%;
    font-size: 24px;
    font-weight: 400;
    color: #1F1F1F;
    padding:100px 0 50px 0;
  }
  .header-text{
    padding-top: 100px;
    font-size: 58px;
    /*font-family: FZZDHJW;*/
  }
  .subtitle{
    font-weight: 600;
    font-size: 36px;
    color: #1F1F1F;
    opacity: 0.6;
    margin: 34px 0;
  }
  .head-img{}
  .head-img img{
    width: 100%;
  }
  .section{
    padding:40px 0;
    /*margin-top:80px;*/
  }
  /*奇数行，隔行变色*/
  .section:nth-of-type(odd){
    background-color: #EAEEF6;
  }
  /*偶数行*/
  .section:nth-of-type(even){
    background-color: rgba(196, 199, 207, 0.3);
  }
  .feature >>> .el-button{
    height: 48px;
    border-radius: 8px;
  }
  .input-title{
    font-size: 24px;
    font-weight: bold;
    color: #333333;
    margin-right: 20px;
  }
  .copy-input{}
  .copy-input >>> .el-input{
    width: 60%;
    min-width: 200px;
  }
  .copy-input >>> .el-input__inner{
    height: 48px;
    border-radius: 8px;
    font-size: 18px;
    font-weight: 400;
    color: #A1A1A1;
  }
  .input-icon{
    height: 48px;
    width: 27px;
    opacity: 0.8;
    line-height: 48px;
    cursor: pointer;
  }
  .feature-top-text{
    font-size: 24px;
    font-weight: 400;
    color: #555555;
  }
  .featureData{
    padding: 20px 20px 20px 20px;
    border-right: 4px solid rgba(66, 92, 225, 0.05);
  }
  .featureBottom{
    border-bottom: 4px solid rgba(66, 92, 225, 0.05);
    padding-top: 0px;
  }
  .NorightBorder{
    border-right:0;
  }
  .feature-title{
    font-size: 26px;
    font-family: SourceHanSansCN;
    font-weight: 500;
    margin-bottom: 10px;
    float:left;
  }
  .feature-text{
    float:left;
    font-size: 20px;
    font-family: SourceHanSansCN;
    font-weight: 400;
    color: rgba(85, 85, 85, 0.85);
  }
  .quick-card{
    margin-top: 40px;
    border-radius: 8px;
  }
  .quick-card >>> .el-card__header{
    padding: 36px;
    background: #F0F2FE;
  }
  .quick-card >>> .el-card__body{
    background: #425CE1;
    opacity: 0.85;
  }
  .card-head{
    text-align: center;
  }
  .card-text{
    font-size: 26px;
    font-family: MicrosoftYaHei;
    font-weight: 400;
    color: #FFFEFE;
    text-align: center;
    transition: .2s;
  }
  .card-text:hover{
    cursor: pointer;
    transform:translateY(-10px);
  }
  .card-text span:hover{
    border-bottom:2px solid white;
    padding-bottom: 4px;
  }
  .left-border{
    border-left: 8px solid rgba(66, 92, 225, 0.2);
    padding-left: 20px;
    margin: 60px 0;
  }
  .blue-title{
    /*float: left;*/
    font-size: 24px;
    font-weight: 600;
    color: #5C72E5;
    margin-bottom: 20px;
  }
  .text-subtitle1{
    /*float: left;*/
    font-size: 20px;
    font-weight: 400;
    color: #333333;
  }
  .wishlist{
    background: #F0F2FE;
    border-radius: 8px;
    width: 100%;
    height: 247px;
    justify-content:space-between;

  }
  .wishlist-text{
    margin-left:60px;
    font-size: 26px;
    font-weight: 400;
    color: #717171;
  }
  .act-head{}
  .act-head span:first-child{
    display: block;
    font-size: 26px;
    font-weight: 600;
    color: #333333;
    margin-bottom: 30px;
  }
  .act-head span:nth-child(2){
    font-size: 18px;
    font-weight: 400;
    color: #333333;
  }
  .more-button{
    width: 88px;
    height: 40px;
    border-radius: 8px;
    padding-bottom: 0;
    padding-top: 0;
    font-size: 18px;
    font-family: SourceHanSansCN;
    font-weight: 400;
  }
  .act-card{
    background: rgba(255, 255, 255, 0.2);
    border-radius: 8px;
    width: 100%;
    margin-top: 36px;
  }
  .act-img{
    height: 210px;
  }
  .act-img img{
    width: 100%;
    height: 100%;
    border-radius: 8px;
  }
  .act-text{
    padding: 20px;
  }
  .act-text-head span:first-child{
    font-size: 22px;
    font-weight: 500;
    color: #666666;
  }
  .act-text-head span:nth-child(2){
    font-size: 18px;
    font-weight: 500;
    color: #666666;
  }
  .act-content{
    margin-top: 18px;
    font-size: 18px;
    font-weight: 400;
    color: #717171;
  }
  .section-title{
    display: block;
    font-size: 26px;
    font-weight: 600;
    color: #333333;
  }
  .community-card{
    padding: 40px!important;
    background: #F0F2FE;
    border-radius: 8px;
  }
  .community-title{
    margin-top: 0;
    margin-bottom: 100px;
  }
  .footer-title{
    font-size: 26px;
    display: block;
    font-family: JetBrains Mono;
    font-weight: 600;
    color: #8590A6;
  }
  .footer-subtitle{
    display: block;
    margin-top: 19px;
    margin-bottom: 37px;
    font-size: 18px;
    font-family: JetBrains Mono;
    font-weight: 600;
    color: #8590A6;
  }
  .email-input{
    margin-bottom: 90px;
  }
  .email-input >>> .el-input{
    width: 60%;
    min-width: 200px;
  }
  .email-input >>> .el-input__inner{
    height: 48px;
    border-radius: 8px;
    font-weight: 400;
    font-size: 18px;
    font-family: SourceHanSansCN;
  }
  .sign {
    width: 116px!important;
    height: 40px;
    font-size: 18px;
    font-weight: 600;
    border-radius: 20px;
    margin-left: 36px;
  }
</style>
