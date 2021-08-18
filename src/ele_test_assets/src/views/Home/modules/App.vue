<template>
  <section class="section">
    <div class="container">
      <el-row>
        <el-col :span="24">
          <el-button type="text" class="text-muted readmore" style="float: right">
            查看更多<i class="el-icon-arrow-right el-icon--right"></i>
          </el-button>
        </el-col>
        <el-col :span="24">
          <el-row :gutter="24">
            <el-col :lg="6" :sm="8" :xs="24" v-for="(item, index) of features" :key="index">
              <div class="card features fea-primary">
                <div class="card-body p-0 content">
                  <el-row :gutter="18">
                    <el-col :span="12">
                      <el-image
                        style="width: 100px; height: 100px"
                        src="https://fuss10.elemecdn.com/e/5d/4a731a90594a4af544c0c25941171jpeg.jpeg"
                      />
                    </el-col>
                    <el-col :span="12">
                      <h5>{{ item.title }}</h5>
                      <p class="text-muted mb-0">Community</p>
                    </el-col>
                  </el-row>
                  <p class="para text-muted mb-0">{{ item.subtext }}</p>
                </div>
              </div>
            </el-col>
          </el-row>
        </el-col>
        <el-col :span="24" class="text-center">
          <a href="javascript:void(0);" class="btn btn-primary">提交应用</a>
        </el-col>
      </el-row>
    </div>
  </section>
</template>

<script>
export default {
  name: 'HomeApp',
  data() {
    return {
      features: [
        {
          title: 'Hign Perform',
          subtext: 'It is a long established fact that a reader.'
        },
        {
          title: 'Best Securities',
          subtext: 'It is a long established fact that a reader.'
        },
        {
          title: 'Trusted Service',
          subtext: 'It is a long established fact that a reader.'
        },
        {
          title: 'Info Technolog',
          subtext: 'It is a long established fact that a reader.'
        },
        {
          title: '24/7 Support',
          subtext: 'It is a long established fact that a reader.'
        },
        {
          title: 'IT Managem',
          subtext: 'It is a long established fact that a reader.'
        },
        {
          title: 'Certified Company',
          subtext: 'It is a long established fact that a reader.'
        },
        {
          title: 'Data Analytics',
          subtext: 'It is a long established fact that a reader.'
        }
      ]
    }
  }
}
</script>

<style lang="scss" scoped>
.section {
  padding: 36px 0;
  background-color: #e4ecfb;
}

.card {
  position: relative !important;
  border: 0;
  border-radius: 24px;
  padding: 1.5rem;
  margin-bottom: 1.5rem;
  background-color: #f8f9fc !important;
  min-height: 210px;
  overflow: hidden !important;
}
</style>
