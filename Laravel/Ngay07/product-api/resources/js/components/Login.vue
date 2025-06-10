<template>
  <div class="container mt-5">
    <div class="row justify-content-center">
      <div class="col-md-6">
        <div class="card shadow">
          <div class="card-header text-center">
            <h2 class="mb-0">Đăng nhập</h2>
          </div>
          <div class="card-body">
            <form @submit.prevent="handleLogin">
              <div class="mb-3">
                <label for="email" class="form-label">Email:</label>
                <input v-model="email" type="email" id="email" class="form-control" required />
              </div>
              <div class="mb-3">
                <label for="password" class="form-label">Mật khẩu:</label>
                <input v-model="password" type="password" id="password" class="form-control" required />
              </div>
              <div class="d-grid">
                <button type="submit" class="btn btn-primary">Đăng nhập</button>
              </div>
            </form>
            <div v-if="error" class="alert alert-danger mt-3" role="alert">
              {{ error }}
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import axios from '../axios.js'
import { ref } from 'vue'
import { useRouter } from 'vue-router'

const router = useRouter()

const email = ref('')
const password = ref('')
const error = ref('')

const handleLogin = async () => {
  error.value = ''

  try {
    
    await axios.get('/sanctum/csrf-cookie')

    const res = await axios.post('/api/login', {
      email: email.value,
      password: password.value,
    })

    console.log('Login OK:', res.data)
    router.push('/products')
  } catch (err) {
    error.value = err.response?.data?.message || 'Đăng nhập thất bại'
  }
}
</script>
