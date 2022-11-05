export const assert = (s) => (condition) => () => {
  if (!condition) {
    throw new Error(s);
  }
}