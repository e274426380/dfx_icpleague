<template>
  <section class="bg-half-170">
    <!-- Feature Start -->
    <div class="container">
      <div class="row">
        <div class="col-lg-6 col-md-6 mt-4 mt-sm-0 pt-2 pt-sm-0">
          <div class="section-title ml-lg-3">
            <h4 class="title mb-4">Why build ICPL?</h4>
            <p class="text-muted">
              The internet has unlocked unprecedented opportunities for collaboration and creation. Now MOTOKO
              technology like open source protocols and decentralized blockchains give us the ability to take that
              co-creation to a new scale. The ICPL community uses this technology to fund and build digital public goods
              projects that serve everyone, and solve our most immediate problems.
            </p>
          </div>
          <div>
            <img src="~@/assets/images/whybuild.png" class="img-fluid" alt="" />
          </div>
        </div>
        <!--end col-->
        <div class="col-lg-6 col-md-6 mt-4 mt-sm-0 pt-2 pt-sm-0">
          <div class="section-title ml-lg-3">
            <h4 class="title mb-4">Open</h4>
            <p class="text-muted">
              Open source code meets open economies. Build resilient projects, better coordination, and positive-sum
              outcomes.
            </p>
          </div>
          <div class="section-title ml-lg-3">
            <h4 class="title mb-4">Empowering</h4>
            <p class="text-muted">
              Growing networks with aligned incentives towards the wellbeing of each participant and the system as a
              whole.
            </p>
          </div>
          <div class="section-title ml-lg-3">
            <h4 class="title mb-4">Collaborative</h4>
            <p class="text-muted">
              Through distributed funding and organizations, we build together toward our shared goals.
            </p>
          </div>
        </div>
        <!--end col-->
      </div>
      <!--end row-->
    </div>
    <!-- Feature End -->

    <el-carousel :interval="4000" type="card" height="400px" indicator-position="none" style="margin-top: 120px">
      <el-carousel-item v-for="item in 4" :key="item">
        <h3 class="medium">{{ item }}</h3>
      </el-carousel-item>
    </el-carousel>
  </section>
</template>

<script>
export default {
  name: 'HomeFeature'
}
</script>

<style lang="scss" scoped>
.bg-half-170 {
  background-color: #eaeef6 !important;
  background: url('~@/assets/images/bg_main.png') top;
  width: 100% !important;
  background-repeat: no-repeat;
  padding: 150px 0 120px;
}

.el-carousel__item h3 {
  color: #475669;
  font-size: 14px;
  opacity: 0.75;
  line-height: 200px;
  margin: 0;
}

.el-carousel__item:nth-child(2n) {
  background-color: #99a9bf;
}

.el-carousel__item:nth-child(2n + 1) {
  background-color: #d3dce6;
}
</style>
