<template>
  <div class="container py-5">
    <div class="d-flex justify-content-between align-items-center mb-4">
      <h1 class="h4 mb-0">🛍️ Danh sách sản phẩm</h1>
      <button @click="router.push('/products/create')" class="btn btn-success">
        + Thêm sản phẩm
      </button>
    </div>

    <!-- Search/filter form -->
    <div class="row mb-4">
      <div class="col-md-4 mb-2">
        <input v-model="searchName" type="text" class="form-control" placeholder="Tìm theo tên sản phẩm..." />
      </div>
      <div class="col-md-2 mb-2">
        <input v-model.number="minPrice" type="number" class="form-control" placeholder="Giá từ" min="0" />
      </div>
      <div class="col-md-2 mb-2">
        <input v-model.number="maxPrice" type="number" class="form-control" placeholder="Giá đến" min="0" />
      </div>
      <div class="col-md-2 mb-2">
        <button class="btn btn-secondary w-100" @click="clearFilter">Xóa lọc</button>
      </div>
    </div>

    <div v-if="loading" class="text-muted">Đang tải dữ liệu...</div>
    <div v-else-if="filteredProducts.length === 0" class="alert alert-info">Không có sản phẩm nào</div>

    <div v-else class="row g-4">
      <div class="col-md-4" v-for="product in filteredProducts" :key="product.id">
        <div class="card h-100 shadow-sm">
          <img v-if="product.image_url" :src="product.image_url" alt="Ảnh sản phẩm" class="card-img-top"
            style="height: 200px; object-fit: cover" />
          <div class="card-body d-flex flex-column">
            <router-link :to="`/products/${product.id}`" class="card-title h5 mb-2 text-decoration-none text-dark"
              style="cursor:pointer">
              {{ product.name }}
            </router-link>
            <p class="card-text text-muted mb-2">Giá: {{ product.price }} đ</p>
            <div class="mt-auto d-flex justify-content-between">
              <button @click="router.push(`/products/${product.id}/edit`)" class="btn btn-outline-primary btn-sm">
                Sửa
              </button>
              <button @click="deleteProduct(product.id)" class="btn btn-outline-danger btn-sm">
                Xóa
              </button>
            </div>
          </div>
        </div>
      </div>
    </div>
    <nav v-if="lastPage > 1" class="mt-4">
      <ul class="pagination justify-content-center">
        <li class="page-item" :class="{ disabled: currentPage === 1 }">
          <button class="page-link" @click="goToPage(currentPage - 1)">Trước</button>
        </li>
        <li
          v-for="page in lastPage"
          :key="page"
          class="page-item"
          :class="{ active: currentPage === page }"
        >
          <button class="page-link" @click="goToPage(page)">{{ page }}</button>
        </li>
        <li class="page-item" :class="{ disabled: currentPage === lastPage }">
          <button class="page-link" @click="goToPage(currentPage + 1)">Sau</button>
        </li>
      </ul>
    </nav>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import axios from '../axios'
import { useRouter } from 'vue-router'

const router = useRouter()
const products = ref([])
const loading = ref(true)
const error = ref('')
const currentPage = ref(1)
const lastPage = ref(1)

// filter state
const searchName = ref('')
const minPrice = ref('')
const maxPrice = ref('')

// computed filter
const filteredProducts = computed(() => {
  return products.value.filter(product => {
    const matchName = product.name.toLowerCase().includes(searchName.value.toLowerCase())
    const matchMin = minPrice.value === '' || product.price >= minPrice.value
    const matchMax = maxPrice.value === '' || product.price <= maxPrice.value
    return matchName && matchMin && matchMax
  })
})

function clearFilter() {
  searchName.value = ''
  minPrice.value = ''
  maxPrice.value = ''
}

async function deleteProduct(id) {
  if (!confirm('Bạn có chắc chắn muốn xóa sản phẩm này?')) return
  try {
    await axios.delete(`/api/products/${id}`)
    products.value = products.value.filter(p => p.id !== id)
  } catch (err) {
    alert('Xóa thất bại!')
    console.error('Lỗi khi xóa sản phẩm:', err)
  }
}

async function fetchProducts(page = 1) {
  loading.value = true
  try {
    const response = await axios.get(`/api/products?page=${page}`)
    products.value = response.data.data
    currentPage.value = response.data.current_page
    lastPage.value = response.data.last_page
  } catch (err) {
    error.value = 'Vui lòng đăng nhập để xem sản phẩm'
    router.push('/login')
  } finally {
    loading.value = false
  }
}

function goToPage(page) {
  if (page >= 1 && page <= lastPage.value) {
    fetchProducts(page)
  }
}

onMounted(() => {
  fetchProducts()
})
</script>