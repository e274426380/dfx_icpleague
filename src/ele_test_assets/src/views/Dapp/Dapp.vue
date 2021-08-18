<template>
  <div>
    <PageNavbar />
    <DappHero />
  </div>
</template>

<script>
import { PageNavbar } from '@/components'
import { DappHero } from './modules'
export default {
  name: 'Dapp',
  components: { PageNavbar, DappHero }
}
</script>
