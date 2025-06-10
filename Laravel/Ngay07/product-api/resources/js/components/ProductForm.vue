<template>
    <div class="p-6 max-w-lg mx-auto bg-white shadow rounded-3 mt-5">
        <h2 class="text-2xl font-bold mb-4 text-center text-primary">
            {{ isEdit ? 'Sửa sản phẩm' : 'Thêm sản phẩm' }}
        </h2>
        <form @submit.prevent="handleSubmit" enctype="multipart/form-data">
            <div class="mb-4">
                <label class="form-label fw-semibold">Tên sản phẩm <span class="text-danger">*</span></label>
                <input v-model="form.name" type="text" class="form-control form-control-lg" required />
            </div>

            <div class="mb-4">
                <label class="form-label fw-semibold">Giá <span class="text-danger">*</span></label>
                <div class="input-group">
                    <input v-model="form.price" type="number" class="form-control form-control-lg" required />
                    <span class="input-group-text">₫</span>
                </div>
            </div>

            <div class="mb-4">
                <label class="form-label fw-semibold">Mô tả</label>
                <textarea v-model="form.description" class="form-control form-control-lg" rows="4"></textarea>
            </div>

            <div class="mb-4">
                <label class="form-label fw-semibold">Ảnh sản phẩm</label>
                <input type="file" @change="onFileChange" class="form-control" />
                <div v-if="form.image_url" class="mt-3 text-center">
                    <img :src="form.image_url" class="img-fluid rounded shadow-sm border p-1" style="max-width: 150px;" />
                </div>
            </div>

            <div class="d-grid mb-3">
                <button type="submit" class="btn btn-success btn-lg">
                    <i class="bi" :class="isEdit ? 'bi-pencil-square' : 'bi-plus-circle'"></i>
                    {{ isEdit ? 'Cập nhật' : 'Tạo mới' }}
                </button>
            </div>

            <div v-if="error" class="alert alert-danger mt-3 text-center">
                {{ error }}
            </div>
        </form>
    </div>
</template>

<script setup>
import { ref, watch, onMounted } from 'vue'
import axios from '../axios'
import { useRouter, useRoute } from 'vue-router'

const router = useRouter()
const route = useRoute()
const isEdit = !!route.params.id
const form = ref({
    name: '',
    price: '',
    description: '',
    image_url: ''
})
const file = ref(null)
const error = ref('')

onMounted(async () => {
    if (isEdit) {
        try {
            const res = await axios.get(`/api/products/${route.params.id}`)
            form.value = {
                name: res.data.name,
                price: res.data.price,
                description: res.data.description,
                image_url: res.data.image_url
            }
        } catch (e) {
            error.value = 'Không tải được sản phẩm'
        }
    }
})

function onFileChange(e) {
    file.value = e.target.files[0]
}

async function handleSubmit() {
    error.value = ''
    const formData = new FormData()
    formData.append('name', form.value.name)
    formData.append('price', form.value.price)
    formData.append('description', form.value.description)
    if (file.value) {
        formData.append('image', file.value)
    }

    try {
        let res
        if (isEdit) {
            res = await axios.post(`/api/products/${route.params.id}?_method=PUT`, formData, {
                headers: { 'Content-Type': 'multipart/form-data' }
            })
        } else {
            res = await axios.post('/api/products', formData, {
                headers: { 'Content-Type': 'multipart/form-data' }
            })
        }
        router.push('/products')
    } catch (e) {
        error.value = e.response?.data?.message || 'Có lỗi xảy ra'
    }
}
</script>
