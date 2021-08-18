<template>
  <!-- Hero Start -->
  <section class="bg-half">
    <div class="container">
      <div class="title-heading text-center">
        <h1 class="para-title font-weight-bold text-white">驱动DFINITY计算机开放应用</h1>
        <p class="para-desc mx-auto text-white">
          ICPL建立了强大社区，我们为互联网计算机开发公共技术与平台，并为开发者提供帮助，让DApps的开发、传播与使用更容易。
        </p>
      </div>
    </div>
  </section>
  <!-- Hero End -->
</template>

<script>
export default {
  name: 'HomeHero'
}
</script>

<style lang="scss" scoped>
.bg-half {
  background-color: #eaeef6;
  background-image: url('~@/assets/images/aboutus.png');
  background-position: bottom;
  background-repeat: no-repeat;
  padding: 170px 0;
}
.para-title {
  text-shadow: 0px 3px 10px rgba(0, 0, 0, 0.2);
  margin-bottom: 1rem;
}
.para-desc {
  max-width: 100%;
  font-size: 30px;
}
</style>
