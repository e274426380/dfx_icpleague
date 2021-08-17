<template>
  <div class="footer">
    <div class="footer-content container">
      <!--预留插槽-->
      <slot></slot>
      <div>
      <el-row>
        <el-col :span="4" :offset="1" :xs=xs>
          <div>
            <p><img alt="ICPL" class="logo" src="@/assets/ICPL.png"></p>
            <p>{{$t("footer.subtitle")}}</p>
            <p class="index-text">Difinity.com</p>
            <!--<div class="record-number">-->
              <!--<a href="https://beian.miit.gov.cn/">沪ICP备2021014954号-1</a>-->
            <!--</div>-->
          </div>
        </el-col>
        <el-col :span="4" :offset="2">
          <ul>
            <li>Private</li>
            <li><a href="https://twitter.com/icpleague_com">Privacy Policy</a></li>
            <li><a href="https://www.icpleague.com">Terms of Use</a></li>
          </ul>
        </el-col>
        <el-col :span="4" :offset="2">
          <ul>
            <li>Commuity</li>
            <li><a href="https://twitter.com/icpleague_com">Form</a></li>
            <li><a href="https://www.icpleague.com">Blog</a></li>
          </ul>
        </el-col>
        <el-col  :span="4" :offset="2">
          <ul>
            <li>Contact Us</li>
            <li><a href="https://twitter.com/icpleague_com">Twitter</a></li>
            <li><a href="https://www.icpleague.com">Medium</a></li>
            <li><a href="https://www.icpleague.com">Discord</a></li>
            <li><a href="https://www.icpleague.com">Telegram</a></li>
            <li><a href="https://github.com/icpleague">Github</a></li>
          </ul>
        </el-col>
      </el-row>
        <el-row style="text-align: center">
          <span class="index-text">
            © 2021 Ethereum Foundation. All rights reserved.
          </span>
        </el-row>
      </div>
    </div>
  </div>
</template>

<script>
    export default {
        name: "new-footer",
      data() {
        return {
          xs:{
            span: 22,
            offset:1
          },
        }
      },
    }
</script>

<style lang="scss" scoped>
  .logo{
    /*width: 151px;*/
    height: 50px;
  }
  .footer {
    background: #1F2937;
    padding-bottom: 50px;
    /*padding: 0px;*/
    color: #8590A6;
    font-weight: bold;
    font-size: 14px;
    p{
      margin-bottom: 0;
      &:nth-child(2){
        font-size: 24px;
      }
    }
    ul{
      padding-left: 0;
      li:first-child{
        font-size: 24px;
        font-weight: 600;
        line-height: 30px;
        margin-bottom: 40px;
      }
      li{
        list-style: none;
        /*display:inline-block;*/
        margin-bottom: 7px;
        margin-right: 20px;
        a{
          color: #8590A6;
          &:hover{
            color: #a44238;
          }
        }
      }
    }
  }
  .index-text{
    font-size: 16px;
    font-weight: 200;
    line-height: 30px;
  }
  .footer-content {
    padding-top: 50px;
  }
  /*备案号样式*/
  .record-number{
    a{
      color: rgba(99, 99, 99, 0.75);
      font-size: 10px;
    }
  }

</style>
