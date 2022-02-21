module.exports = {
  content: ["./index.html", "./src/**/*.{vue,js,ts,jsx,tsx}"],
  theme: {
    extend: {
      colors: {
        darkt: {
          900: "#0D0709",
          800: "#191315",
          700: "#241F21",
          600: "#302B2D",
          500: "#3C3739",
          400: "#474344",
          300: "#534F50",
          200: "#5F5B5C",
          100: "#6A6768",
          50: "#767374"
        },
        "blue-sapphire": "#0B4F6C",
      },
      animation: {
        fadeIn: "fadeIn 0.125s ease-in forwards",
        fadeOut: "fadeIn 0.1s ease-out backwards",
      },
      keyframes: {
        fadeIn: {
          "0%": { opacity: 0 },
          "100%": { opacity: 1 },
        },
      },
    },
  },
  plugins: [],
};
