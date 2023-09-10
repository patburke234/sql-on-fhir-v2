import { runTests } from './reference-implementation/processor.mjs'

import Ajv from 'ajv'
const ajv = new Ajv({ allErrors: true })

import path from 'path'

console.log('Linting tests...')

let tests = []
import fs from 'fs/promises'
const schema = JSON.parse(await fs.readFile('./tests.schema.json'))
const validate = ajv.compile(schema)

const files = await fs.readdir('./v1')
console.log('v1/')

let broken_views = 0
for (const file of files) {
  if (path.extname(file) !== '.json') {
    continue
  }

  let test = JSON.parse(await fs.readFile('v1/' + file))
  let res = validate(test)

  if (res == true) {
    console.log('* ' + file + ' is schema-valid')
    const testResults = await runTests(test)
    console.log("TR", testResults);

    if (testResults.tests.every((r) => r.result.passed)) {
      console.log('* ' + file + ' tests all pass')
      tests.push({ file: 'v1/' + file, title: test.title })
    } else {
      broken_views += 1
      console.error('* ' + file + ' has failed tests')
      console.error(
        JSON.stringify(
          testResults.tests
            .filter((t) => !t.result.passed)
            .map((t) => ({
              title: t.title,
              expect: t.expect,
              result: t.result
            })),
          true,
          ' '
        )
      )
    }
  } else {
    broken_views += 1
    console.error('* ' + file)
    console.error(JSON.stringify(validate.errors, true, ' '))
  }
}
if (broken_views > 0) {
  console.log(`Broken tests: ${broken_views}. Exiting with error.`)
  process.exit(1)
}
console.log('Success, writing index')
await fs.writeFile('index.json', JSON.stringify(tests, null, 2), 'utf8')