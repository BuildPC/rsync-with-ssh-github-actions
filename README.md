# rsync-with-ssh-github-actions
rsync over ssh with command run support

This repo is an adaptation from
> https://github.com/AEnterprise/rsync-deploy  
> https://github.com/alinz/ssh-scp-action  

the above repos.

All the actual credit goes to the original developers.

# USAGE
```yaml
- name: Deploy with rsync
  uses: BuildPC/rsync-with-ssh-github-actions@master
  env:
    HELLO: cool
    MESSAGE: hello world
  with:
    key: ${{ secrets.SSH_KEY }}
    host: example.com
    port: 22
    user: john
    destination: /var/www/
    # runs this on remove server
    ssh_before: |
      echo $HELLO
      echo $MESSAGE
      ls -lath

    # then run these commands
    ssh_after: |
      echo $HELLO
      echo $MESSAGE
      ls -lath
```
