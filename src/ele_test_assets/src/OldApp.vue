<template>
  <div id="app">
    <div>{{ internetComputerGreeting || 'Loading message from Internet Computer...' }}
	<el-input v-model="input" placeholder="请输入内容"></el-input>
	<i class="el-icon-edit"></i>
<i class="el-icon-share"></i>
<i class="el-icon-delete"></i>
<el-button type="primary" icon="el-icon-search">搜索</el-button>
	</div>
  </div>
</template>

<script>
import { Actor, HttpAgent } from '@dfinity/agent';
import { idlFactory as ele_test_idl } from 'dfx-generated/ele_test/ele_test.did.js';
import canisterIds from '../../../.dfx/local/canister_ids.json'

export default {
  data: () => {
    return {
      internetComputerGreeting: '',
	   input: ''
    };
  },
  created() {
	const ele_test_id = new URLSearchParams(window.location.search).get("ele_testId") || canisterIds.ele_test.local;

	const agent = new HttpAgent();
	agent.fetchRootKey();
	const ele_test = Actor.createActor(ele_test_idl, { agent, canisterId: ele_test_id });
	  ele_test.greet(window.prompt("Enter your name:")).then(greeting => {
      this.internetComputerGreeting = greeting
    });
  }
}
</script>
