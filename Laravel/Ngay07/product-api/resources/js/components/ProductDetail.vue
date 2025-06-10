<template>
  <div class="container py-5">
    <div class="mb-4">
      <button @click="$router.back()" class="btn btn-outline-primary">
        ← Quay lại danh sách
      </button>
    </div>

    <div v-if="loading" class="text-center text-muted">
      <div class="spinner-border text-primary" role="status">
        <span class="visually-hidden">Đang tải...</span>
      </div>
      <p class="mt-2">Đang tải dữ liệu sản phẩm...</p>
    </div>

    <div v-else-if="!product" class="alert alert-warning">
      Không tìm thấy sản phẩm.
    </div>

    <div v-else class="row g-5 align-items-start">
      <div class="col-md-5 text-center">
        <img
          v-if="product.image_url"
          :src="product.image_url"
          alt="Product image"
          class="img-fluid rounded shadow-sm border"
          style="max-height: 350px; object-fit: contain;"
        />
        <div v-else class="text-muted fst-italic">Không có hình ảnh</div>
      </div>

      <div class="col-md-7">
        <div class="card shadow-sm">
          <div class="card-body">
            <h2 class="card-title h4 mb-3">{{ product.name }}</h2>
            <h4 class="text-danger fw-bold mb-3">{{ formatPrice(product.price) }}</h4>
            <p class="text-muted">{{ product.description || 'Không có mô tả.' }}</p>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import axios from '../axios'
import { useRoute } from 'vue-router'

const route = useRoute()
const product = ref(null)
const loading = ref(true)

onMounted(async () => {
  try {
    const response = await axios.get(`/api/products/${route.params.id}`)
    product.value = response.data
  } catch (error) {
    console.error('Không tải được sản phẩm:', error)
  } finally {
    loading.value = false
  }
})

function formatPrice(price) {
  if (!price) return '0 đ'
  return new Intl.NumberFormat('vi-VN').format(price) + ' đ'
}
</script>
