<template>
  <!--导航条，用fix固定-->
  <el-menu id="nav" class="nav-menu" mode="horizontal" text-color="#333333" active-text-color="#425CE1" style="margin-top: 20px;">
    <el-row>
      <el-col class="nav-button" :offset="0" :span="24" :xs=xs>
        <router-link to="/">
        <img class="nav-icon" src='../assets/ICPL.png'>
        </router-link>
        <div class="flex-center">
          <router-link to="library">
            <el-menu-item class="item-right" index="1">{{$t('button.library')}}</el-menu-item>
          </router-link>
          <router-link to="dapp">
          <el-menu-item class="item-right" index="2">{{$t('button.dapps')}}</el-menu-item>
          </router-link>
          <el-menu-item class="item-right" index="3">{{$t('button.hackathon')}}</el-menu-item>
          <el-menu-item class="item-right" index="4">{{$t('button.forum')}}</el-menu-item>
          <el-menu-item class="item-right" index="5">{{$t('button.grant')}}</el-menu-item>
        </div>
        <el-button class="login i-button">{{$t('button.login')}}</el-button>
      </el-col>
    </el-row>
  </el-menu>
</template>

<script>
  export default {
    name: "new-nav",
    data() {
      return {
        xs: {
          span: 22,
          offset: 1
        },
      }
    },
    methods: {
      // 滚动一定像素以后，改变导航条背景颜色
      handleScroll () { //改变元素#searchBar的top值
        var scrollTop = window.pageYOffset || document.documentElement.scrollTop || document.body.scrollTop;
        if(scrollTop>=129){
          document.querySelector('#nav').style.backgroundColor = "#ffffff";
          document.querySelector('#nav').style.marginTop = "0";
          document.querySelector('.nav-menu').style.borderBottom = "1px soild black";
        }else {
          var scrollMargin=20-scrollTop/10;
          document.querySelector('#nav').style.marginTop = scrollMargin+"px";
          document.querySelector('#nav').style.backgroundColor = "rgba(000, 000, 000, 0)";
        }
      },
    },
    mounted() {
      //给window添加一个滚动滚动监听事件
      window.addEventListener('scroll', this.handleScroll);
    },
    destroyed () {
      //离开该页面需要移除这个监听的事件
      window.removeEventListener('scroll', this.handleScroll);
    },
    }
</script>

<style scoped>
  /*导航条的高度固定，由图标logo大小决定，但按钮的居中写死的，改变高度，必须改变按钮的居中margin*/
  .nav-menu{
    /*font-weight:bold;*/
    /*border: 0;*/
    /*border-bottom:2px solid #F4F4F4!important;*/
    /*box-shadow: 0 0 10px rgba(255, 255, 255, 0.2);*/
    /*让导航栏透明*/
    background-color: rgba(255, 255, 255, 0);
    color: #333333;
    /*background: #142032;*/
    font-size: 22px;
    position:fixed;
    z-index: 99;
    width: 100%;
  }
  #nav{
    border-bottom: 0;
  }
  /*登录按钮*/
  .login{
    margin: 5px 20px;
    width: 118px;
    height: 38px;
    line-height: 1px;
    border-radius: 8px!important;
    font-size: 18px;
    font-weight: 500;
    /*height: 44px;*/
  }
  /*导航条logo*/
  .nav-icon {
    margin-left: 10px;
    float: left;
    height: 30px;
    line-height: 60px;
  }
  .item-right {
    /*width: 150px;*/
    font-size: 22px;
    font-weight: 500;
    /*文字垂直居中*/
    text-align: center;
    /*height: 120px;*/
    /*line-height:120px;*/
  }
  .nav-button{
    display:flex;
    /*横向滚动条*/
    overflow-x: auto;
    align-items: center;
    justify-content:space-between;
    /*padding: 35px 0;*/
  }
  .flex-center{
    display:flex;
    align-items: center;
  }
  /*导航条item的样式*/
  .nav-button >>> .el-menu-item{
    /*border-radius: 16px;*/
  }
  .nav-button >>> .el-menu-item:hover{
    background: rgba(234, 238, 246, 0.16);
    color: #425CE1!important;
  }
  .nav-button >>> .el-menu-item:focus{
    background: rgba(234, 238, 246, 0.16);
  }
</style>
