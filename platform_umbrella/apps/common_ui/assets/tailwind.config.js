// See the Tailwind configuration guide for advanced usage
// https://tailwindcss.com/docs/configuration

const path = require('path');
const plugin = require('tailwindcss/plugin');
const colors = require('tailwindcss/colors');
const defaultTheme = require('tailwindcss/defaultTheme');
const forms = require('@tailwindcss/forms');
const typography = require('@tailwindcss/typography');

const primary = {
  light: '#FFA8CB',
  DEFAULT: '#FC408B',
  dark: '#DE2E74',
  // TODO: Deprecate these after removing Petal
  50: '#FFF5F9',
  100: '#FFECF3',
  200: '#FECFE2',
  300: '#FEB3D1',
  400: '#FD79AE',
  500: '#FC408B',
  600: '#E33A7D',
  700: '#BD3068',
  800: '#972653',
  900: '#7B1F44',
};

const secondary = {
  light: '#DEFAF8',
  DEFAULT: '#97EFE9',
  dark: '#36E0D4',
  // TODO: Deprecate these after removing Petal
  50: '#FFFFFF',
  100: '#FFFFFF',
  200: '#FFFFFF',
  300: '#DEFAF8',
  400: '#BAF4F0',
  500: '#97EFE9',
  600: '#66E8DF',
  700: '#36E0D4',
  800: '#1EC0B5',
  900: '#169087',
};

const success = {
  light: '#79E2BB',
  DEFAULT: '#36D399',
  dark: '#26AB7A',
  // TODO: Deprecate these after removing Petal
  50: '#CDF4E5',
  100: '#BCF0DD',
  200: '#9AE9CC',
  300: '#79E2BB',
  400: '#57DAAA',
  500: '#36D399',
  600: '#26AB7A',
  700: '#1B7D59',
  800: '#114F38',
  900: '#072118',
};

const warning = {
  light: '#FBDBA2',
  DEFAULT: '#F6AE2D',
  dark: '#E1940A',
  // TODO: Deprecate these after removing Petal
  50: '#FEF2DD',
  100: '#FDEAC9',
  200: '#FBDBA2',
  300: '#F9CC7B',
  400: '#F8BD54',
  500: '#F6AE2D',
  600: '#E1940A',
  700: '#AB7107',
  800: '#764D05',
  900: '#402A03',
};

const error = {
  light: '#FEE2E2',
  DEFAULT: '#ED4C5C',
  dark: '#991B1B',
  // TODO: Deprecate these after removing Petal
  50: '#D42F40',
  100: '#C62939',
  200: '#A4222F',
  300: '#831B25',
  400: '#61141C',
  500: '#3F0D12',
  600: '#100305',
  700: '#000000',
  800: '#000000',
  900: '#000000',
};

const gray = {
  lightest: '#FAFAFA',
  lighter: '#DADADA',
  light: '#999A9F',
  DEFAULT: '#7F7F7F',
  dark: '#545155',
  darker: '#38383A',
  darkest: '#1C1C1E',
  // Used for dark mode
  'darker-tint': '#4E535F',
  'darkest-tint': '#21242B',
  // TODO: Deprecate these after removing Petal
  ...colors.zinc,
};

module.exports = {
  important: '.common-ui',
  content: [
    // Use absolute paths so this config can be shared between umbrella apps
    path.resolve(__dirname, 'js/**/*.js'),
    path.resolve(__dirname, '../lib/**/*.{heex,ex}'),
    path.resolve(__dirname, '../storybook/**/*.exs'),
    path.resolve(__dirname, '../../control_server_web/assets/js/**/*.js'),
    path.resolve(__dirname, '../../control_server_web/lib/**/*.{heex,ex}'),
    path.resolve(__dirname, '../../home_base_web/assets/js/**/*.js'),
    path.resolve(__dirname, '../../home_base_web/lib/**/*.{heex,ex}'),
    path.resolve(
      __dirname,
      '../../../deps/petal_components/lib/**/*.{heex,ex}'
    ),
  ],
  theme: {
    // Note when changing: keep `storybook/colors.story.exs` up to date
    extend: {
      colors: {
        primary,
        secondary,
        success,
        warning,
        error,
        gray,
        // TODO: Remove these after removing Petal
        danger: error,
        info: secondary,
      },
      fontFamily: {
        sans: ['"Inter Variable"', ...defaultTheme.fontFamily.sans],
        mono: ['"JetBrains Mono Variable"', ...defaultTheme.fontFamily.mono],
      },
      backgroundImage: {
        caret: `url("data:image/svg+xml,%3csvg viewBox='0 0 9 6' fill='%23999A9F' xmlns='http://www.w3.org/2000/svg'%3e%3cpath d='M1.023,1.537L2.934,3.637L4.101,4.926C4.596,5.469 5.399,5.469 5.894,4.926L8.978,1.537C9.383,1.092 9.091,0.333 8.525,0.333L5.185,0.333L1.476,0.333C0.904,0.333 0.618,1.092 1.023,1.537Z' /%3e%3c/svg%3e")`,
      },
    },
  },
  plugins: [
    forms,
    typography,

    // Allows prefixing tailwind classes with LiveView classes to add rules
    // only when LiveView classes are applied, for example:
    //
    //     <div class="phx-click-loading:animate-ping">
    //
    plugin(({ addVariant }) =>
      addVariant('phx-feedback', ['label:not(.phx-no-feedback) &'])
    ),
    plugin(({ addVariant }) =>
      addVariant('phx-no-feedback', ['.phx-no-feedback&', '.phx-no-feedback &'])
    ),
    plugin(({ addVariant }) =>
      addVariant('phx-click-loading', [
        '.phx-click-loading&',
        '.phx-click-loading &',
      ])
    ),
    plugin(({ addVariant }) =>
      addVariant('phx-submit-loading', [
        '.phx-submit-loading&',
        '.phx-submit-loading &',
      ])
    ),
    plugin(({ addVariant }) =>
      addVariant('phx-change-loading', [
        '.phx-change-loading&',
        '.phx-change-loading &',
      ])
    ),
  ],
};
