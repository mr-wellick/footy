import daisyui from "daisyui";

/** @type {import('tailwindcss').Config} */
export default {
  content: ["./src/views/**/*.tsx"],
  theme: {
    extend: {},
  },
  daisyui: {
    themes: ["cyberpunk"],
  },
  plugins: [daisyui],
};
