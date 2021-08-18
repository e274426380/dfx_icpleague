<template>
  <section class="section">
    <div class="container">
      <el-row :gutter="40" class="card_row">
        <el-col :md="12" :xs="24">
          <el-card class="mb-3">
            <div slot="header" class="card_header">
              <el-image
                class="card_header_image"
                src="https://fuss10.elemecdn.com/e/5d/4a731a90594a4af544c0c25941171jpeg.jpeg"
              />
              <span class="card_header_title">卡片名称</span>
            </div>
            <div>
              <span>青春是一个短暂的美梦, 当你醒来时, 它早已消失无踪</span>
              <el-divider></el-divider>
              <span>少量的邪恶足以抵消全部高贵的品质, 害得人声名狼藉</span>
              <el-divider></el-divider>
              <span>头上一片晴天，心中一个想念</span>
              <el-divider></el-divider>
            </div>
          </el-card>
        </el-col>
        <el-col :md="12" :xs="24">
          <el-card>
            <div slot="header" class="card_header">
              <el-image
                class="card_header_image"
                src="https://fuss10.elemecdn.com/e/5d/4a731a90594a4af544c0c25941171jpeg.jpeg"
              />
              <span class="card_header_title">开发者的总结</span>
            </div>
            <div>
              <span>青春是一个短暂的美梦, 当你醒来时, 它早已消失无踪</span>
              <el-divider></el-divider>
              <span>少量的邪恶足以抵消全部高贵的品质, 害得人声名狼藉</span>
              <el-divider></el-divider>
              <span>头上一片晴天，心中一个想念</span>
              <el-divider></el-divider>
            </div>
          </el-card>
        </el-col>
      </el-row>
    </div>
  </section>
</template>

<script>
export default {
  name: 'HomeCard'
}
</script>

<style lang="scss" scoped>
.section {
  background-color: #eaeef6;
  padding: 0;
}

.section ::v-deep .el-card {
  border-radius: 36px;
}

.card_row {
  position: relative;
  top: 120px;
  z-index: 999;
}

.card_header {
  display: flex;
  align-items: center;

  &_image {
    width: 50px;
    height: 50px;
    border-radius: 50%;
  }

  &_title {
    font-size: 18px;
    margin-left: 20px;
  }
}
</style>
