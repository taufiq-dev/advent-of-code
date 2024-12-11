import fs from 'node:fs';
import path from 'node:path';

// Constants for patterns to improve maintainability
const PATTERNS = {
  MUL: /mul\((\d+),(\d+)\)/,
  MUL_G: /mul\((\d+),(\d+)\)/,
  DO: /do\(\)/,
  DONT: /don't\(\)/,
  ALL_G: /(mul\(\d+,\d+\)|do\(\)|don't\(\))/g,
} as const;

const processFilePartOne = async (filePath: string) => {
  try {
    const data = await fs.promises.readFile(filePath, 'utf8');
    // const pattern = /mul\(\d+,\d+\)/g;
    const matches = data.match(PATTERNS.MUL_G);
    const totalSum = matches?.reduce((acc, curr) => {
      const match = curr.match(PATTERNS.MUL);
      if (match) {
        const [, a, b] = match;
        return acc + Number.parseInt(a) * Number.parseInt(b);
      }
      return acc;
    }, 0);
    console.log('total sum', totalSum);
  } catch (err) {
    console.error('Error reading file:', err);
    throw err;
  }
};

const processFilePartTwo = async (filePath: string) => {
  try {
    const data = await fs.promises.readFile(filePath, 'utf8');
    const matches = data.match(PATTERNS.ALL_G);
    let isMulEnabled = true;
    const filteredMatches = matches?.reduce((acc, curr) => {
      const mulMatch = curr.match(PATTERNS.MUL);
      const doMatch = curr.match(PATTERNS.DO);
      const dontMatch = curr.match(PATTERNS.DONT);
      if (mulMatch && isMulEnabled) {
        acc.push(curr);
      }
      if (doMatch) {
        isMulEnabled = true;
      }
      if (dontMatch) {
        isMulEnabled = false;
      }
      return acc;
    }, [] as string[]);

    const totalSum = filteredMatches?.reduce((acc, curr) => {
      const match = curr.match(PATTERNS.MUL);
      if (match) {
        const [, a, b] = match;
        return acc + Number.parseInt(a) * Number.parseInt(b);
      }
      return acc;
    }, 0);
    console.log('total sum', totalSum);
  } catch (err) {
    console.error('Error reading file:', err);
    throw err;
  }
};

// Main execution
const filePath = path.join(__dirname, 'input.txt');
await processFilePartOne(filePath);
await processFilePartTwo(filePath);
