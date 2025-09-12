import base64
import concurrent.futures
import logging
import re
import subprocess
from concurrent.futures import FIRST_COMPLETED, ThreadPoolExecutor
from hashlib import sha256

from tqdm import tqdm


target_re = re.compile(b'M[O0]TH')


def check_cert(i):
  try:
    p = subprocess.run(
      ['openssl', 'x509', '-req', '-days', '10950', '-in', 'cert.csr', '-signkey', 'key.pem', '-outform', 'DER', '-set_serial', str(i)],
      stderr=subprocess.PIPE,
      stdin=subprocess.DEVNULL,
      stdout=subprocess.PIPE,
      check=True
    )
  except subprocess.CalledProcessError as e:
    progress.write(e.stderr)
    raise

  h = base64.b32encode(sha256(p.stdout).digest())
  if target_re.match(h):
    progress.write(f'Writing {i}.der')
    with open(f'{i}.der', 'wb') as f:
      f.write(p.stdout)
    return True

  return False


workers = 128

block = 0
jobs = set()
running = True
progress = tqdm()

with ThreadPoolExecutor() as executor:
  while running:
    if len(jobs) < workers:
      jobs.add(executor.submit(lambda i=block: check_cert(i)))
      block += 1
      progress.update(1)
      continue

    done, jobs = concurrent.futures.wait(jobs, timeout=1, return_when=FIRST_COMPLETED)
    for fut in done:
      try:
        if fut.result():
          running = False
      except:
        logging.exception('task exception')