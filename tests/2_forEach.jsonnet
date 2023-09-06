{
  name: "forEach",
  desc: "Flattening nested elements with `forEach`",
  resource: [
    {
      resourceType: "Patient",
      id: "pt1",
      name: [
        {
          family: "F1",
          given: ["G1.1.1","G1.1.2"]
        },
        {
          family: "F1'",
          use: "official",
          given: ["G1.2.1","G1.2.2"]
        },
      ],
      birthDate: "1951",
      address: [{city: "C1.1"}],
      contact: [
        {
          relationship: [
            {coding: [{code: 'C1RC1', system: "C1RS1"}]}
          ],
          telecom: [
            {value: 'phone1', system: "phone"},
            {value: 'email1', system: "email"}
          ],
          organization: {reference: 'Organization/o1'}
        }
      ]
    },
    {
      resourceType: "Patient",
      id: "pt2",
      birthDate: "1952",
      name: [
        {
          family: "F2.1",
          use: "official",
          given: ["G2.1.1", "G2.1.2"],
        },
        {
          family: "F2.2",
          given: ["G2.2.1", "G2.2.2"],
        },
      ],
    },
    {
      resourceType: "Patient",
      id: "pt3",
      birthDate: "1953",
      name: [
        {
          family: "F3.1",
          use: "official",
          given: ["G3.1.1", "G3.1.2"],
        },
        {
          family: "F3.2",
          given: ["G3.2.1", "G3.2.2"],
        },
      ],
    },
  ],
  views: [
    {
      title: "basic forEach",
      desc: "...",
      view: {
        resource: "Patient",
        select: [
          {path: "id", alias: "id"},
          {
            forEach: "name",
            select: [
              {path: 'family'}
            ]
          }
        ]
      },
      result: [
        {id: "pt1", family: "F1.1"},
        {id: "pt1", family: "F1.2"},
        {id: "pt2", family: "F2.1"},
        {id: "pt2", family: "F2.2"},
        {id: "pt3", family: "F3.2"},
        {id: "pt4", family: "F3.2"},
      ]
    },
    {
      title: "forEach in forEach",
      desc: "...",
      view: {
        resource: "Patient",
        select: [
          {path: "id", alias: "id"},
          {
            forEach: "contact",
            select: [
              {
                path: "organization.getId()",
                alias: "org"
              },
              {
                forEach: "telecom.where(system='phone')",
                select: [{path: "value", alias: "phone"}]
              },
              {
                forEach: "relationship",
                select: [
                  {path: "code", alias: "rel_code"},
                  {path: "system", alias: "rel_system"},
                ]
              },
            ]
          }
        ]
      },
      result: [
        {id: "pt1", family: "F1.1"},
        {id: "pt1", family: "F1.2"},
        {id: "pt2", family: "F2.1"},
        {id: "pt2", family: "F2.2"},
        {id: "pt3", family: "F3.2"},
        {id: "pt4", family: "F3.2"},
      ]
    },
  ]
}
