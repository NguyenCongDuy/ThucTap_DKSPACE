import { createRouter, createWebHistory } from 'vue-router'
import ProductList from './components/ProductList.vue'
import ProductDetail from './components/ProductDetail.vue'
import ProductForm from './components/ProductForm.vue'
import Login from './components/Login.vue'

const routes = [
    {
        path: '/', redirect: '/login'
    },
    {
        path: '/login', 
        name: 'login', 
        component: Login
    },
    {
        path: '/products', 
        name: 'Products', 
        component: ProductList,
        meta: { requiresAuth: true }
    },
    {
        path: '/products/:id', 
        name: 'ProductDetail', 
        component: ProductDetail,
        meta: { requiresAuth: true }
    },
    {
        path: '/products/create',
        name: 'ProductCreate',
        component: ProductForm,
        meta: { requiresAuth: true }
    },
    {
        path: '/products/:id/edit',
        name: 'ProductEdit',
        component: ProductForm,
        meta: { requiresAuth: true }
    }
]

const router = createRouter({
    history: createWebHistory(),
    routes,
})

export default router