import fs from 'node:fs';
import path from 'node:path';
const filePath = path.join(__dirname, 'input.txt');

fs.readFile(filePath, 'utf8', (err, data) => {
  if (err) {
    console.error(err);
    return;
  }

  const lines = data.split('\n'); // Split into lines

  const left: string[] = [];
  const right: string[] = [];

  for (const line of lines) {
    const [a, b] = line.split(/\s+/).map(Number);
    left.push(a);
    right.push(b);
  }

  left.sort();
  right.sort();
  const distances: number[] = [];

  for (let i = 0; i < left.length; i++) {
    distances.push(
      Math.abs(Number.parseInt(left[i]) - Number.parseInt(right[i])),
    );
  }
  const totalDistance = distances.reduce((acc, curr) => acc + curr, 0);
  console.log('total distance', totalDistance);

  const similarity: number[] = [];
  for (let i = 0; i < left.length; i++) {
    const a = right.filter((val) => val === left[i]).length;
    similarity.push(Number.parseInt(left[i]) * a);
  }

  console.log('similarity', similarity);
  const totalSimilarity = similarity.reduce((acc, curr) => acc + curr, 0);
  console.log('total similarity', totalSimilarity);
});
