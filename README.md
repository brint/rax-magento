rax-magento Cookbook
==========================
This cookbook leverages many community cookbooks to do an installation of
Magento Community Edition.

Usage
-----
#### rax-magento::default
Just include `rax-magento` in your node's `run_list`:

```json
{
  "name":"my_node",
  "run_list": [
    "recipe[rax-magento]"
  ]
}
```

Contributing
------------
1. Fork the repository on Github
2. Create a named feature branch (like `add_component_x`)
3. Write your change
4. Write tests for your change (if applicable)
5. Run the tests, ensuring they all pass
6. Submit a Pull Request using Github

License and Authors
-------------------
* Author:: Brint O'Hearn (brint.ohearn@rackspace.com)
