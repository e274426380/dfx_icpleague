<template>
  <div>
    <!-- Footer Start -->
    <footer class="footer">
      <div class="container">
        <el-row :gutter="24">
          <el-col :span="24" class="mb-4">
            <img src="@/assets/images/logo@2x.png" height="37" />
          </el-col>
          <el-col :md="6" :sm="12" :xs="24">
            <h4 class="footer_title">Website</h4>
            <ul class="list-unstyled mt-4">
              <li>
                <a href="#" target="_blank" class="footer_text">Difinity.com</a>
              </li>
            </ul>
          </el-col>
          <el-col :md="6" :sm="12" :xs="24">
            <h4 class="footer_title">Private</h4>
            <ul class="list-unstyled mt-4">
              <li>
                <a href="https://twitter.com/icpleague_com" target="_blank" class="footer_text">Privacy Policy</a>
              </li>
              <li>
                <a href="https://www.icpleague.com" target="_blank" class="footer_text">Terms of Use</a>
              </li>
            </ul>
          </el-col>
          <el-col :md="6" :sm="12" :xs="24">
            <h4 class="footer_title">Commuity</h4>
            <ul class="list-unstyled mt-4">
              <li>
                <a href="https://twitter.com/icpleague_com" target="_blank" class="footer_text">Form</a>
              </li>
              <li>
                <a href="https://www.icpleague.com" target="_blank" class="footer_text">Blog</a>
              </li>
            </ul>
          </el-col>
          <el-col :md="6" :sm="12" :xs="24">
            <h4 class="footer_title">Contact Us</h4>
            <ul class="list-unstyled mt-4">
              <li>
                <a href="https://twitter.com/icpleague_com" target="_blank" class="footer_text">Twitter</a>
              </li>
              <li>
                <a href="https://www.icpleague.com" target="_blank" class="footer_text">Medium</a>
              </li>
              <li>
                <a href="https://www.icpleague.com" target="_blank" class="footer_text">Discord</a>
              </li>
              <li>
                <a href="https://www.icpleague.com" target="_blank" class="footer_text">Telegram</a>
              </li>
              <li>
                <a href="https://www.icpleague.com" target="_blank" class="footer_text">Github</a>
              </li>
            </ul>
          </el-col>
        </el-row>
      </div>
      <!--end container-->
      <div class="container text-center mt-3">
        <p class="mb-0">© {{ new Date().getFullYear() }} Ethereum Foundation. All rights reserved.</p>
      </div>
    </footer>
    <!--end footer-->
  </div>
</template>

<style lang="scss" scoped>
.footer {
  padding: 50px 0 32px;
  color: #8590a6;

  &_title {
    letter-spacing: 1px;
    font-weight: 500;
    margin: 0;
  }

  &_text {
    color: #8590a6;
  }

  a.footer_text:hover,
  a.footer_text:focus {
    color: #ffffff !important;
  }
}
</style>
