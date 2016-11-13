require! <[fs]>
files = fs.readdir-sync \post  .map -> "post/#it"

trend = (filename) ->
  score = {"推": 1, "噓": -1, "→": 0}
  lines = (fs.read-file-sync filename .toString!).split \\n
  author = lines.map(->/^ +作者 +(\S+)/.exec(it)).filter(->it).map(->it.1).0
  title  = lines.map(->/^ +標題 +(\S.+)/.exec(it)).filter(->it).map(->it.1).0
  scores = lines.map(->/^ ([推噓→])   /.exec it)
    .filter(->it).map(->it.1).map(->score[it])
  sum = []
  for i from 0 til scores.length =>
    sum.push(if i => sum[i - 1] + scores[i] else scores[0])
  if sum.length < 100 => return null
  output = []
  for i from 0 til sum.length => output.push [i, sum[i]]
  return [filename,author,title,output]
final = files.map(-> trend it).filter(-> it)
fs.write-file-sync \result.json, JSON.stringify(final)
