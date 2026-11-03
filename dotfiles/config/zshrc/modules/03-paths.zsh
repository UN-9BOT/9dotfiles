# Saved PATH priority; never hard-code the captured project virtualenv.
_recovered_path=(
  '/home/unbot/.pyenv/shims'
  '/home/unbot/.pyenv/bin'
  '/home/unbot/bin'
  '/home/unbot/.npm-global/bin'
  '/home/unbot/.cargo/bin'
  '/home/unbot/go/bin'
  '/home/unbot/.bun/bin'
  '/home/unbot/.local/bin'
  '/bin'
  '/home/unbot/.local/share/zinit/polaris/bin'
  '/usr/local/sbin'
  '/usr/local/bin'
  '/usr/bin'
  '/opt/android-sdk/platform-tools'
  '/var/lib/flatpak/exports/bin'
  '/usr/lib/jvm/default/bin'
  '/usr/bin/site_perl'
  '/usr/bin/vendor_perl'
  '/usr/bin/core_perl'
  '/opt/rocm/bin'
)
if [[ -n ${VIRTUAL_ENV:-} && -d "$VIRTUAL_ENV/bin" ]]; then
  path=("$VIRTUAL_ENV/bin" "${_recovered_path[@]}" "${path[@]}")
else
  path=("${_recovered_path[@]}" "${path[@]}")
fi
typeset -gU path
export PATH
unset _recovered_path
