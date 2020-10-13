# IAM

Configuration creates several users and adds them to several groups.

Different sets of policies are applied to created groups.

Configuration's output will show user's encrypted passwords.

All options are set in terraforms.tfvars.

You must change ``keybase_profile`` to your https://keybase.io/ profile for configuration to work.

You should change account alias and password policy in ``account-wide-settings``.

Users, groups, group memberships and policy attachments can be applied in any order.