<template>
  <!-- Hero Start -->
  <section class="bg-half-170 d-table w-100" id="home">
    <div class="container">
      <div class="row align-items-center">
        <div class="col-lg-6 col-md-6 mt-4 pt-2 mt-sm-0 pt-sm-0">
          <img src="~@/assets/images/dapp_img.png" class="img-fluid" alt="" />
        </div>
        <!--end col-->
        <div class="col-lg-6 col-md-6">
          <div class="title-heading mt-4">
            <h1 class="heading mb-3">Divinity Library</h1>
            <p class="para-desc text-muted">
              Where you can find out more Diffinity dapps , or upload your dapps . Where you can find out more Diffinity
              dapps , or upload your dapps .
            </p>
          </div>
        </div>
        <!--end col-->
      </div>
      <!--end row-->
    </div>
    <!--end container-->
  </section>
  <!--end section-->
  <!-- Hero End -->
</template>

<script>
export default {
  name: 'LibraryHero'
}
</script>

<style lang="scss" scoped>
.bg-half-170 {
  background: url('~@/assets/images/bg_dapp.png') top;
  background-repeat: no-repeat;
  padding: 90px 0 20px;
}
</style>
