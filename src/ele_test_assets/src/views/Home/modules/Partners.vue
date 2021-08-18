<template>
  <section class="bg-half">
    <div class="container">
      <div class="row justify-content-center">
        <div class="col-12 text-center">
          <div class="section-title mb-4 pb-2">
            <h4 class="title mt-3">How it works ?</h4>
            <span class="title-badge"></span>
            <p class="text-muted para-desc mb-0 mx-auto">
              Start working with Landrickthat can provide everything you need to generate awareness, drive traffic,
              connect.
            </p>
          </div>
        </div>
        <!--end col-->
      </div>
      <!--end row-->

      <div class="row">
        <div class="col-lg-6 col-md-6 col-12 mt-4 pt-2">
          <div class="text-start features feature-clean rounded">
            <h4 class="text-dark">Property Lookup</h4>
            <p class="text-muted mt-3 mb-4">
              Composed in a pseudo-Latin language which more or less pseudo-Latin language corresponds.
            </p>
            <a href="javascript:void(0)" class="btn btn-primary">开始组队</a>
          </div>
        </div>
        <!--end col-->

        <div class="col-lg-6 col-md-6 col-12 mt-4 pt-2">
          <div class="text-start features feature-clean rounded">
            <h4 class="text-dark">Buy / Sell Property</h4>
            <p class="text-muted mt-3 mb-4">
              Composed in a pseudo-Latin language which more or less pseudo-Latin language corresponds.
            </p>
            <a href="javascript:void(0)" class="btn btn-primary">发起合作</a>
          </div>
        </div>
        <!--end col-->
      </div>
      <!--end row-->

      <div class="row justify-content-center" style="margin-top: 80px">
        <div class="col-12 text-center">
          <h4>从 ICPL 获取最新信息</h4>
        </div>
        <div class="col-12">
          <div class="form-group">
            <div class="input-group">
              <input
                name="email"
                id="email"
                type="email"
                class="form-control rounded"
                placeholder="输入你的电子邮箱:"
                required
                aria-describedby="newssubscribebtn"
              />
              <div class="ml-4">
                <!-- <a href="#" class="btn btn-pills btn-primary"> Primary </a> -->
                <button class="btn btn-primary btn-pills submitBnt" type="submit" id="newssubscribebtn">订阅</button>
              </div>
            </div>
          </div>
        </div>
        <!--end col-->
      </div>

      <!-- Partners start -->
      <section class="py-4">
        <div class="container">
          <div class="row justify-content-center">
            <div class="col-lg-3 col-md-3 col-6 text-center py-4">
              <img src="~@/assets/images/logo/odaily.png" class="avatar avatar-ex-sm" alt="" />
            </div>
            <!--end col-->

            <div class="col-lg-3 col-md-3 col-6 text-center py-4">
              <img src="~@/assets/images/logo/tangent.png" class="avatar avatar-ex-sm" alt="" />
            </div>
            <!--end col-->

            <div class="col-lg-3 col-md-3 col-6 text-center py-4">
              <img src="~@/assets/images/logo/panews.png" class="avatar avatar-ex-sm" alt="" />
            </div>
            <!--end col-->

            <div class="col-lg-3 col-md-3 col-6 text-center py-4">
              <img src="~@/assets/images/logo/ipfsnews.png" class="avatar avatar-ex-sm" alt="" />
            </div>
            <!--end col-->

            <div class="col-lg-3 col-md-3 col-6 text-center py-4">
              <img src="~@/assets/images/logo/chainnews.png" class="avatar avatar-ex-sm" alt="" />
            </div>
            <!--end col-->

            <div class="col-lg-3 col-md-3 col-6 text-center py-4">
              <img src="~@/assets/images/logo/boliancaijing.png" class="avatar avatar-ex-sm" alt="" />
            </div>
            <!--end col-->

            <div class="col-lg-3 col-md-3 col-6 text-center py-4">
              <img src="~@/assets/images/logo/tuoniaox.png" class="avatar avatar-ex-sm" alt="" />
            </div>
            <!--end col-->

            <div class="col-lg-3 col-md-3 col-6 text-center py-4">
              <img src="~@/assets/images/logo/coinvoice.png" class="avatar avatar-ex-sm" alt="" />
            </div>
            <!--end col-->

            <div class="col-lg-4 col-md-4 col-6 text-center py-4">
              <img src="~@/assets/images/logo/Dfinityclub.png" class="avatar avatar-ex-sm" alt="" />
            </div>
            <!--end col-->

            <div class="col-lg-2 col-md-2 col-6 text-center py-4">
              <img src="~@/assets/images/logo/2link.png" class="avatar avatar-ex-sm" alt="" />
            </div>
            <!--end col-->

            <div class="col-lg-3 col-md-3 col-6 text-center py-4">
              <img src="~@/assets/images/logo/toudengcang.png" class="avatar avatar-ex-sm" alt="" />
            </div>
            <!--end col-->

            <div class="col-lg-3 col-md-3 col-6 text-center py-4">
              <img src="~@/assets/images/logo/Blocklike.png" class="avatar avatar-ex-sm" alt="" />
            </div>
            <!--end col-->
          </div>
          <!--end row-->
        </div>
        <!--end container-->
      </section>
      <!--end section-->
      <!-- Partners End -->
    </div>
  </section>
</template>

<script>
export default {
  name: 'HomePartners'
}
</script>

<style lang="scss" scoped>
.bg-half {
  background-color: #eaeef6 !important;
  background: url('~@/assets/images/sections.png') top;
  width: 100% !important;
  background-repeat: no-repeat;
}

.title-badge {
  display: inline-block;
  width: 67px;
  height: 6px;
  background-color: #425ce1;
  border-radius: 3px;
  margin: 28px 0;
}
</style>
