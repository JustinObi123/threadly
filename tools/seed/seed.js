// Run with:
//   cd tools/seed
//   npm install firebase-admin
//   node seed.js  (expects GOOGLE_APPLICATION_CREDENTIALS pointing to a service account JSON)
//
// Seeds: 2 stores, 8 products with images (Unsplash), categories.

const admin = require('firebase-admin');
admin.initializeApp({ credential: admin.credential.applicationDefault() });
const db = admin.firestore();
const now = new Date().toISOString();

const CATEGORIES = [
  ['men','Men',1],['women','Women',2],['kids','Kids',3],['shoes','Shoes',4],
  ['accessories','Accessories',5],['streetwear','Streetwear',6],
  ['formalwear','Formalwear',7],['sportswear','Sportswear',8],
  ['luxury','Luxury',9],['thrift','Thrift',10],
];

const STORES = [
  { id: 'store_atlas', vendorId: 'vendor_atlas', name: 'Atlas Apparel', slug: 'atlas-apparel',
    description: 'Modern essentials for everyday wear.', rating: 4.7, ratingCount: 132, isActive: true },
  { id: 'store_drift', vendorId: 'vendor_drift', name: 'Drift Street', slug: 'drift-street',
    description: 'Independent streetwear from Brooklyn.', rating: 4.5, ratingCount: 87, isActive: true },
];

const PRODUCTS = [
  { vendorId:'vendor_atlas', storeId:'store_atlas', storeName:'Atlas Apparel',
    title:'Heavyweight Crew Tee', brand:'Atlas', categoryId:'men', gender:'men',
    condition:'new', basePrice:38, discountPrice:29, totalStock:120,
    sizes:['S','M','L','XL'], colors:['Black','Bone','Olive'], tags:['tee','basics'],
    images:['https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?w=800'],
    rating:4.6, ratingCount:48, salesCount:210 },
  { vendorId:'vendor_atlas', storeId:'store_atlas', storeName:'Atlas Apparel',
    title:'Pleated Wide-Leg Trouser', brand:'Atlas', categoryId:'women', gender:'women',
    condition:'new', basePrice:96, totalStock:60,
    sizes:['XS','S','M','L'], colors:['Charcoal','Cream'], tags:['trousers'],
    images:['https://images.unsplash.com/photo-1551803091-e20673f15770?w=800'],
    rating:4.8, ratingCount:33, salesCount:90 },
  { vendorId:'vendor_drift', storeId:'store_drift', storeName:'Drift Street',
    title:'Boxy Logo Hoodie', brand:'Drift', categoryId:'streetwear', gender:'unisex',
    condition:'new', basePrice:120, discountPrice:89, totalStock:80,
    sizes:['S','M','L','XL'], colors:['Black','Washed Red'], tags:['hoodie','streetwear'],
    images:['https://images.unsplash.com/photo-1556821840-3a63f95609a7?w=800'],
    rating:4.4, ratingCount:62, salesCount:175 },
  { vendorId:'vendor_drift', storeId:'store_drift', storeName:'Drift Street',
    title:'Cargo Utility Pant', brand:'Drift', categoryId:'streetwear', gender:'unisex',
    condition:'new', basePrice:110, totalStock:55,
    sizes:['S','M','L','XL'], colors:['Khaki','Black'], tags:['pants','cargo'],
    images:['https://images.unsplash.com/photo-1542272604-787c3835535d?w=800'],
    rating:4.3, ratingCount:25, salesCount:60 },
  { vendorId:'vendor_atlas', storeId:'store_atlas', storeName:'Atlas Apparel',
    title:'Linen Camp Shirt', brand:'Atlas', categoryId:'men', gender:'men',
    condition:'new', basePrice:68, totalStock:40,
    sizes:['S','M','L','XL'], colors:['Sand','Sky'], tags:['shirt','linen'],
    images:['https://images.unsplash.com/photo-1602810318383-e386cc2a3ccf?w=800'],
    rating:4.5, ratingCount:19, salesCount:42 },
  { vendorId:'vendor_drift', storeId:'store_drift', storeName:'Drift Street',
    title:'Court Low Sneaker', brand:'Drift', categoryId:'shoes', gender:'unisex',
    condition:'new', basePrice:145, totalStock:35,
    sizes:['8','9','10','11','12'], colors:['White','Bone'], tags:['sneakers'],
    images:['https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=800'],
    rating:4.7, ratingCount:54, salesCount:130 },
  { vendorId:'vendor_atlas', storeId:'store_atlas', storeName:'Atlas Apparel',
    title:'Cashmere Beanie', brand:'Atlas', categoryId:'accessories', gender:'unisex',
    condition:'new', basePrice:48, totalStock:200,
    sizes:['OS'], colors:['Black','Camel','Forest'], tags:['accessories','winter'],
    images:['https://images.unsplash.com/photo-1576566588028-4147f3842f27?w=800'],
    rating:4.6, ratingCount:71, salesCount:260 },
  { vendorId:'vendor_drift', storeId:'store_drift', storeName:'Drift Street',
    title:'Vintage Denim Jacket', brand:'Drift', categoryId:'thrift', gender:'unisex',
    condition:'used', basePrice:75, totalStock:1,
    sizes:['M'], colors:['Indigo'], tags:['vintage','denim'],
    images:['https://images.unsplash.com/photo-1543087903-1ac2ec7aa8c5?w=800'],
    rating:5.0, ratingCount:4, salesCount:0 },
];

(async () => {
  for (const [id, name, order] of CATEGORIES) {
    await db.collection('categories').doc(id).set({ name, slug: id, order });
  }
  for (const s of STORES) {
    await db.collection('stores').doc(s.id).set({ ...s });
  }
  for (let i = 0; i < PRODUCTS.length; i++) {
    const p = PRODUCTS[i];
    await db.collection('products').doc(`p_${i+1}`).set({
      ...p,
      currency: 'USD',
      isActive: true,
      approvalStatus: 'approved',
      createdAt: now,
    });
  }
  console.log('Seed complete.');
  process.exit(0);
})().catch(e => { console.error(e); process.exit(1); });
