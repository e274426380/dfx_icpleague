<template>
  <div class="home">
    <PageNavbar />
    <HomeHero />
    <HomeFeature />
    <HomeApp />
    <HomeCard />
    <HomePartners />
    <PageFooter />
  </div>
</template>

<script>
import { PageNavbar, PageFooter } from '@/components'
import { HomeHero, HomeFeature, HomeApp, HomeCard, HomePartners } from './modules'
export default {
  name: 'Home',
  components: { PageNavbar, HomeHero, HomeFeature, HomeApp, HomeCard, HomePartners, PageFooter }
}
</script>
