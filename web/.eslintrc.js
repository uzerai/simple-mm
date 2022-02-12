module.exports = {
  env: {
    browser: true,
    es2021: true,
  },
  extends: [
    'eslint:recommended',
    'plugin:vue/vue3-recommended',
  ],
  parserOptions: {
    parser: "@babel/eslint-parser",
  },
  plugins: ["vue"],
  rules: {
    "vue/prop-name-casing": ["warn", "snake_case"]
  },
};
