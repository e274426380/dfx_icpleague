<template>
  <div>
    <PageNavbar />
    <LibraryHero />
  </div>
</template>

<script>
import { PageNavbar } from '@/components'
import { LibraryHero } from './modules'
export default {
  name: 'Library',
  components: { PageNavbar, LibraryHero }
}
</script>
