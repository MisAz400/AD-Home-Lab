# Active Directory Home Lab

A hands-on home lab built to simulate a real corporate IT environment using Windows Server 2022 and Active Directory Domain Services. Built from scratch as part of my transition into Systems/Desktop Administration.

---

## Lab Overview

| Component | Details |
|---|---|
| Hypervisor | Oracle VirtualBox |
| OS | Windows Server 2022 Standard Evaluation |
| Domain | mishalab.local |
| Domain Controller | DC01 |
| Forest Functional Level | Windows Server 2016 |
| Status | Active — Phase 3 Complete |

---

## Why I Built This

Most mid-size companies run on-premises Active Directory as the backbone of their IT environment. Every user account, password policy, and security rule flows through the Domain Controller. As someone with Azure AD administration experience transitioning into a Systems/Desktop Admin role, I built this lab to get hands-on experience with on-prem AD — the same environment I'll be managing in the field.

---

## What's Been Completed

### Phase 1 — Environment Setup
- Downloaded Windows Server 2022 evaluation ISO from Microsoft Evaluation Center (180-day free license)
- Created a virtual machine in VirtualBox with the following specs:
  - 2048 MB RAM
  - 2 vCPUs
  - 50 GB virtual disk
- Installed Windows Server 2022 with Desktop Experience (GUI)
- Renamed the server to **DC01** following standard IT naming conventions
- Configured a static IP address:
  - IP: 192.168.1.10
  - Subnet mask: 255.255.255.0
  - Gateway: 192.168.1.1
  - DNS: 127.0.0.1 (self-referencing — required for AD)

### Phase 2 — Active Directory Installation
- Installed the **Active Directory Domain Services** role via Server Manager
- Promoted the server to a Domain Controller using the AD DS Configuration Wizard
- Selected **Add a new forest** and created the root domain: **mishalab.local**
- Configured Domain Controller options:
  - DNS Server: enabled
  - Global Catalog: enabled
  - Set DSRM (Directory Services Restore Mode) recovery password
- Completed prerequisites check and installed — server automatically rebooted as Domain Controller
- Verified successful promotion: login screen now shows **MISHALAB\Administrator**

### Phase 3 — Organizational Units, Users & Groups
- Created 4 Organizational Units (OUs) mirroring a real company department structure:
  - **IT**
  - **HR**
  - **Finance**
  - **Engineering**
- Created 2–3 user accounts inside each OU with realistic names and logon names
- Created Security Groups in each OU:
  - **IT-Admins**
  - **HR-Managers**
  - **Finance-Managers**
  - **Engineering-Team**
- Added users to their corresponding Security Groups using the Member Of tab

**Onboarding workflow practiced:**
1. Create new user account in correct OU
2. Assign user to appropriate Security Group
3. Set password and configure account options
4. Enable account

**Offboarding workflow practiced:**
1. Disable the user account
2. Remove user from all Security Groups
3. Move account to **Disabled Users** OU for record keeping

### Phase 4 — Group Policy Objects (GPOs)
Configured three GPOs to enforce security policies across the domain:

**1. Password Policy** (linked to domain level — applies to all users)
| Setting | Value |
|---|---|
| Minimum password length | 12 characters |
| Password complexity | Enabled |
| Maximum password age | 90 days |
| Minimum password age | 1 day |

**2. Account Lockout Policy** (linked to domain level — applies to all users)
| Setting | Value |
|---|---|
| Account lockout threshold | 5 failed attempts |
| Account lockout duration | 15 minutes |
| Reset lockout counter after | 15 minutes |

**3. HR Desktop Restrictions GPO** (scoped to HR OU only)
- Created a new GPO linked specifically to the HR OU
- Enabled **Prohibit access to Control Panel and PC settings**
- HR users are blocked from changing system settings, uninstalling software, or modifying network configurations
- All other OUs are unaffected — demonstrates understanding of scoped policy application

**Applied all GPOs using:**
```
gpupdate /force
```

---

## Screenshots

| Screenshot | Description |
|---|---|
| `ou-it-users.png` | IT OU with users and IT-Admins group |
| `ou-hr-users.png` | HR OU with users and HR-Managers group |
| `ou-finance-users.png` | Finance OU with users and Finance-Managers group |
| `ou-engineering-users.png` | Engineering OU with users and Engineering-Team group |
| `ou-disabled-users.png` | Disabled Users OU showing offboarded account |
| `gpo-passwordpolicy.png` | Password Policy GPO settings |
| `gpo-accountlockout.png` | Account Lockout Policy settings |
| `gpo-desktoprestrictions.png` | HR Desktop Restrictions GPO scoped to HR OU |
| `gpo-gpupdate.png` | gpupdate /force confirming policies applied |

---

## AD Environment Structure

```
mishalab.local (Forest/Domain)
└── DC01 (Domain Controller — 192.168.1.10)
    ├── IT (OU)
    │   ├── IT-Admins (Security Group)
    │   └── Users: jsmith, sjohnson, mdavis
    ├── HR (OU) — HR-Desktop-Restrictions GPO applied
    │   ├── HR-Managers (Security Group)
    │   └── Users: [HR staff]
    ├── Finance (OU)
    │   ├── Finance-Managers (Security Group)
    │   └── Users: [Finance staff]
    ├── Engineering (OU)
    │   ├── Engineering-Team (Security Group)
    │   └── Users: [Engineering staff]
    └── Disabled Users (OU)
        └── [Offboarded accounts]
```

---

## In Progress

- [ ] PowerShell automation — password resets, account unlocks, inactive account search
- [ ] Bulk user creation script using CSV input
- [ ] Microsoft 365 admin lab — Azure AD, Conditional Access, Exchange Online
- [ ] Document all PowerShell scripts in /scripts folder

---

## Skills Demonstrated

- Windows Server 2022 installation and configuration from scratch
- Active Directory Domain Services installation and domain promotion
- Domain Controller setup including DNS and static IP configuration
- Organizational Unit design mirroring real company department structure
- User lifecycle management — full onboarding and offboarding workflows
- Security Group creation and Role Based Access Control (RBAC)
- Group Policy Object creation, configuration, and scoped application
- Understanding of AD hierarchy: Forest → Domain → OUs → Users & Groups
- IT documentation and lab writeup

---

## How This Relates to Real IT Work

| Lab Task | Real World Equivalent |
|---|---|
| Creating users in OUs | Onboarding new hires |
| Disabling and moving accounts | Offboarding departing employees |
| Adding users to Security Groups | Assigning system access by role |
| Password Policy GPO | Company-wide password compliance |
| Account Lockout GPO | Brute force attack prevention |
| Scoped HR GPO | Least privilege — restricting non-IT staff |
| gpupdate /force | Pushing emergency policy changes to all machines |

---

## Tools Used

- [VirtualBox](https://www.virtualbox.org/) — free hypervisor
- [Windows Server 2022 Evaluation](https://www.microsoft.com/en-us/evalcenter/evaluate-windows-server-2022) — free 180-day eval from Microsoft
- Active Directory Users and Computers (ADUC)
- Group Policy Management Console (GPMC)
- Command Prompt — gpupdate /force

---

*This lab is actively being built. PowerShell automation scripts and Microsoft 365 integration coming next.*
