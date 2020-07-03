const { User, Actor, Scence, Character, ActorCharactor } = require('./index');

const bootStrap = async () => {
  // await Scence.bulkCreate([
  //   {
  //     name: 'Canh 1',
  //     description: 'Canh Te Thien danh yeu quai',
  //     filmingAddress: 'Trung Quoc',
  //     filmingStartDate: new Date().toISOString(),
  //     filmingEndDate: new Date().toISOString(),
  //     setQuantity: 10,
  //   },
  //   {
  //     name: 'Canh 2',
  //     description: 'Canh Đường Tam Tạng giải cứu Tôn Ngộ Không',
  //     filmingAddress: 'Trung Quoc',
  //     filmingStartDate: new Date().toISOString(),
  //     filmingEndDate: new Date().toISOString(),
  //     setQuantity: 8,
  //   },
  //   {
  //     name: 'Canh 3',
  //     description: 'Canh Đường Tam Tạng gặp Bát Giới',
  //     filmingAddress: 'Trung Quoc',
  //     filmingStartDate: new Date().toISOString(),
  //     filmingEndDate: new Date().toISOString(),
  //     setQuantity: 5,
  //   },
  // ]);
  // const scence1 = await Scence.findByPk(1);
  // await Character.bulkCreate([
  //   { name: 'Tôn Ngộ Không', ScenceId: scence1.id },
  //   { name: 'Đường Tăng', ScenceId: scence1.id },
  //   { name: 'Chu Bát Giới', ScenceId: scence1.id },
  //   { name: 'Sa Ngộ Tĩnh', ScenceId: scence1.id },
  // ]);
  // User.bulkCreate([
  //   {
  //     username: 'actor1@gmail.com',
  //     password: 'actor1',
  //     role: 'actor',
  //     name: 'Ngoc Trinh',
  //     phone: '0987654234',
  //     gender: 'male',
  //   },
  //   {
  //     username: 'actor2@gmail.com',
  //     password: 'actor2',
  //     role: 'actor',
  //     name: 'Thay Ba',
  //     phone: '0987654234',
  //     gender: 'female',
  //   },
  //   {
  //     username: 'admin@gmail.com',
  //     password: 'admin',
  //     role: 'admin',
  //     name: 'Hung Bui',
  //     phone: '0987654234',
  //     gender: 'male',
  //   },
  // ]);
  // ACTOR

  // Actor.bulkCreate([
  //   {
  //     description: 'Americian Actor',
  //     imageURL: 'https://www.gstatic.com/tv/thumb/persons/435/435_v9_bc.jpg',
  //     UserId: 3,
  //   },
  //   {
  //     description: 'Teacher Three',
  //     imageURL: 'https://nguoinoitieng.tv/images/nnt/100/0/beoj.jpg',
  //     UserId: 2,
  //   },
  //   {
  //     description: 'Ngoc Trinh',
  //     imageURL:
  //       'https://media.congluan.vn/files/thanhduyen/2020/05/01/ngoc-trinh-lay-chong-1231.jpg',
  //     UserId: 1,
  //   },
  // ]);

  await ActorCharactor.bulkCreate([
    // { ActorId: 4, CharacterId: 1 },
    // { ActorId: 4, CharacterId: 3 },
    // { ActorId: 5, CharacterId: 1 },
    // { ActorId: 5, CharacterId: 4 },
    { ActorId: 6, CharacterId: 3 },
  ]);
};

module.exports = bootStrap;
