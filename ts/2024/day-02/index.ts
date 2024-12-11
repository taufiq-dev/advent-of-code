import fs from 'node:fs';
import path from 'node:path';

const MIN_DIFF = 1;
const MAX_DIFF = 3;

const isSequenceSafe = (report: number[]): boolean => {
  if (report.length < 2) return true;

  // Determine if sequence is increasing by checking first two numbers
  const isIncreasing = report[1] > report[0];

  // Use a single loop instead of duplicating logic
  for (let i = 0; i < report.length - 1; i++) {
    const diff = isIncreasing
      ? report[i + 1] - report[i]
      : report[i] - report[i + 1];

    if (diff < MIN_DIFF || diff > MAX_DIFF) {
      return false;
    }
  }

  return true;
};

const checkReport = (report: number[]): boolean => {
  // First check if sequence is already safe without removal
  if (isSequenceSafe(report)) return true;

  // Try removing each number one at a time and check if sequence becomes safe
  for (let i = 0; i < report.length; i++) {
    const modifiedReport = [...report.slice(0, i), ...report.slice(i + 1)];
    if (isSequenceSafe(modifiedReport)) {
      return true;
    }
  }

  return false;
};

// Use promises instead of callbacks for better error handling
const processFile = async (filePath: string): Promise<number> => {
  try {
    const data = await fs.promises.readFile(filePath, 'utf8');
    return data
      .trim()
      .split('\n')
      .reduce(
        (safeCount, line) =>
          safeCount + Number(checkReport(line.trim().split(/\s+/).map(Number))),
        0,
      );
  } catch (err) {
    console.error('Error reading file:', err);
    throw err;
  }
};

console.log(checkReport([11, 12, 15, 18, 19, 18]));

// Main execution
const filePath = path.join(__dirname, 'input.txt');
processFile(filePath).then(console.log).catch(process.exit);
