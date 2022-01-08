module.exports = {
  env: {
    browser: true,
    es2021: true,
  },
  extends: ["plugin:vue/vue3-essential", "eslint:recommended", "@vue/prettier"],
  parserOptions: {
    parser: "@babel/eslint-parser",
  },
  plugins: ["vue"],
  rules: {},
};
