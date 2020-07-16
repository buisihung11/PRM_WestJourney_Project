# Journey to west

A new Flutter project.

## Getting Started

### Task

#### Phase 1

1. [x] Change naming navigation to unamed
2. [x] Fix drawer naviagtion
3. [x] Fix `Actor` navigation
4. [x] Fix `Equipment` navigation
5. [x] Fix `Tribulation` navigation
6. [x] Complete Update + Create Screen for `Actor`, `Equipment`, `Tribulation`
7. [x] Implemnt Login + Logout
8. [x] Authorization 

#### Phase 2

1. [x] Check filter when get `Tribulation`
2. [x] Show **empty** when fetch empty for *Actor*
3. [x] Tribulation detail for `Actor`
4. [x] Add `canDelete`  to `ListItem`
5. [x] Fetch `Tribulation`, `Actor`, `Equipment` for *Admin* (empty)
6. [x] Delete `Actor`, `Equipment` for *Admin* 

#### Phase 3

1. [x] Create `Actor`, `Equipment` for *Admin* 
2. [x] Update `Actor`, `Equipment` for *Admin* 
3. [x] Fix equipment detail for status value

#### Phase 4
1. [x] Update `Tribulation`, for *Admin* 
   1. [x] Update quantity when edit equipment
   2. [x] Edit Character
      1. [x] Upload file
      2. [x] Choose actor for character
   3. [x] Handle update Tribulation

#### Phase 5

1. [x] Create `Tribulation`for *Admin*
2. [x] Delete `Tribulation`, for *Admin* 

#### Phase 6

1. [ ] Save FCM to server when loggin success
2. [ ] Receive **`Notification`** for *Actor*

<!-- // DateTimeField(
                                  //   format: DateFormat("dd-MM-yyyy"),
                                  //   initialValue: DateFormat("dd-MM-yyyy")
                                  //       .parse(
                                  //           tribulationInfo.filmingStartDate),
                                  //   onSaved: (value) {
                                  //     tribulationInfo.filmingStartDate =
                                  //         value.toUtc().toString();
                                  //   },
                                  //   onShowPicker: (context, currentValue) {
                                  //     return showDatePicker(
                                  //         context: context,
                                  //         firstDate: DateTime(2000),
                                  //         initialDate:
                                  //             currentValue ?? DateTime.now(),
                                  //         lastDate: DateTime(2100));
                                  //   },
                                  // ), -->