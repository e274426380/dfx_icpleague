<template>
  <!-- Navbar STart -->
  <header id="topnav" class="defaultscroll sticky">
    <div class="container">
      <!-- Start Logo container-->
      <router-link class="logo" to="/">
        <img src="~@/assets/images/logo@2x.png" width="82" height="20" />
      </router-link>
      <!-- End Logo container-->
      <!--Start Login Button-->
      <div class="buy-button">
        <a href="#" target="_blank" class="btn btn-primary btn-sm mr-3">中文</a>
        <a href="#" target="_blank" class="btn btn-primary btn-sm">ICP登录</a>
      </div>
      <!--End Login Button-->
      <div class="menu-extras">
        <div class="menu-item">
          <!-- Mobile menu toggle-->
          <a class="navbar-toggle" @click="toggleMenu()" :class="{ open: isCondensed === true }">
            <div class="lines">
              <span v-for="index in 3" :key="index"></span>
            </div>
          </a>
          <!-- End mobile menu toggle-->
        </div>
      </div>

      <div id="navigation">
        <!-- Navigation Menu-->
        <ul class="navigation-menu">
          <li class="navigation-menu">
            <router-link to="/library" class="side-nav-link-ref">知识库</router-link>
          </li>
          <li class="navigation-menu">
            <router-link to="/dapp" class="side-nav-link-ref">Dapp库</router-link>
          </li>
          <li class="navigation-menu">
            <router-link to="/hackathon" class="side-nav-link-ref">黑客松</router-link>
          </li>
          <li class="navigation-menu">
            <a href="https://icpleague.com" target="_blank">广场</a>
          </li>
          <li class="navigation-menu">
            <router-link to="/sponsor" class="side-nav-link-ref">开发者赞助</router-link>
          </li>
        </ul>
        <!--end navigation menu-->
      </div>
      <!--end navigation-->
    </div>
    <!--end container-->
  </header>
  <!--end header-->
  <!-- Navbar End -->
</template>

<script>
/**
 * Navbar component
 */
export default {
  name: 'PageNavbar',
  data() {
    return {
      isCondensed: false
    }
  },

  mounted() {
    this.onwindowScroll()
    this.getMenuItem()
  },
  methods: {
    onwindowScroll() {
      window.onscroll = function () {
        if (document.body.scrollTop > 50 || document.documentElement.scrollTop > 50) {
          document.getElementById('topnav').classList.add('nav-sticky')
        } else {
          document.getElementById('topnav').classList.remove('nav-sticky')
        }

        // 页面右下角返回顶部按钮
        // if (document.body.scrollTop > 100 || document.documentElement.scrollTop > 100) {
        //   document.getElementById('back-to-top').style.display = 'inline'
        // } else {
        //   document.getElementById('back-to-top').style.display = 'none'
        // }
      }
    },
    getMenuItem() {
      const links = document.getElementsByClassName('side-nav-link-ref')
      let matchingMenuItem = null
      for (let i = 0; i < links.length; i++) {
        if (window.location.pathname === links[i].pathname) {
          matchingMenuItem = links[i]
          break
        }
      }

      if (matchingMenuItem) {
        matchingMenuItem.classList.add('active')
        const parent = matchingMenuItem.parentElement

        /**
         * TODO: This is hard coded way of expading/activating parent menu dropdown and working till level 3.
         * We should come up with non hard coded approach
         */
        if (parent) {
          parent.classList.add('active')
          const parent2 = parent.parentElement
          if (parent2) {
            parent2.classList.add('active')
            const parent3 = parent2.parentElement
            if (parent3) {
              parent3.classList.add('active')
              const parent4 = parent3.parentElement
              if (parent4) {
                const parent5 = parent4.parentElement
                parent5.classList.add('active')
              }
            }
          }
        }
      }
    },
    toggleMenu() {
      this.isCondensed = !this.isCondensed
      if (this.isCondensed) {
        document.getElementById('navigation').style.display = 'block'
      } else document.getElementById('navigation').style.display = 'none'
    }
  }
}
</script>

<style lang="scss" scoped>
#topnav .navigation-menu > li > a {
  font-size: 16px;
}
</style>
