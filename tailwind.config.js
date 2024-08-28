/** @type {import('tailwindcss').Config} */
export default {
  content: ["./src/**/*.tsx"],
  theme: {
    extend: {},
  },
  daisyui: {
    themes: ["cyberpunk"],
  },
  plugins: [require("daisyui")],
};
